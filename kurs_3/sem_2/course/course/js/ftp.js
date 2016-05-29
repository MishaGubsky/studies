'use strict';

var Net = require('net');
var EventEmitter = require('events').EventEmitter;
var es = require('event-stream');
var ResponseParser = require('ftp-response-parser');
var ListingParser = require('parse-listing');
var util = require('util');
var fs = require('fs');
var once = require('once');
var unorm = require('unorm');

var debug = require('debug')('jsftp:general');
var dbgCommand = require('debug')('jsftp:command');
var dbgResponse = require('debug')('jsftp:response');

var FTP_PORT = 21; 
var TIMEOUT = 10 * 60 * 1000;
var IDLE_TIME = 30000;
var NOOP = function() {};
var COMMANDS = [
  // Commands without parameters
  'abor', 'pwd', 'cdup', 'feat', 'noop', 'quit', 'pasv', 'syst',
  // Commands with one or more parameters
  'cwd', 'dele', 'list', 'mdtm', 'mkd', 'mode', 'nlst', 'pass', 'retr', 'rmd',
  'rnfr', 'rnto', 'site', 'stat', 'stor', 'type', 'user', 'xrmd', 'opts',
  // Extended features
  'chmod', 'size'
];

var expectedMarks = {
  marks: [125, 150],
  ignore: 226
};

// Regular Expressions
var RE_PASV = /([-\d]+,[-\d]+,[-\d]+,[-\d]+),([-\d]+),([-\d]+)/;
var FTP_NEWLINE = /\r\n|\n/;

function getPasvPort(text, callback) {
  var match = RE_PASV.exec(text);
  if (!match) {
    return callback(new Error('Bad passive host/port combination'));
  }

  callback(null, {
    host: match[1].replace(/,/g, '.'),
    port: (parseInt(match[2], 10) & 255) * 256 + (parseInt(match[3], 10) & 255)
  });
}

function runCmd(cmd) {
  var callback = NOOP;
  var args = [].slice.call(arguments);
  var completeCmd = args.shift();

  if (typeof args[args.length - 1] === 'function') {
    callback = args.pop();
  }

  completeCmd += ' ' + args.join(' ');
  this.execute(completeCmd.trim(), callback);
}

var Ftp = function(cfg) {
  var self = this;
  Object.keys(cfg).forEach(function(option) {
    self[option] = self[option] || cfg[option];
  });

  EventEmitter.call(this);

  this.useList = true;
  this.port = this.port || FTP_PORT;

  this.commandQueue = [];

  this.raw = function() { return runCmd.apply(self, arguments); };

  COMMANDS.forEach(function(cmd) { self.raw[cmd] = runCmd.bind(self, cmd); });


  this._createSocket(this.port, this.host);
};

util.inherits(Ftp, EventEmitter);



Ftp.prototype.reemit = function(event) {
  var self = this;
  return function(data) {
    self.emit(event, data);
    debug('event:' + event, data || {});
  };
};

Ftp.prototype._createSocket = function(port, host, firstAction) {
  if (this.socket && this.socket.destroy) {
    this.socket.destroy();
  }

  if (this.resParser) {
    this.resParser.end();
  }
  this.resParser = new ResponseParser();

  this.authenticated = false;
  this.socket = Net.createConnection(port, host, firstAction || NOOP);
  this.socket.on('connect', this.reemit('connect'));
  this.socket.on('timeout', this.reemit('timeout'));

  this.pipeline = es.pipeline(this.socket, this.resParser);

  var self = this;

  this.pipeline.on('data', function(data) {
    self.emit('data', data);
    dbgResponse(data.text);
    self.parseResponse.call(self, data);
  });
  this.pipeline.on('error', this.reemit('error'));
};

Ftp.prototype.parseResponse = function(response) {
  if (this.commandQueue.length === 0) return;
  if ([220].indexOf(response.code) > -1) return;

  var next = this.commandQueue[0].callback;
  if (response.isMark) {
    if (!next.expectsMark ||
        next.expectsMark.marks.indexOf(response.code) === -1) {
      return;
    }

    if (next.expectsMark.ignore) {
      this.ignoreCmdCode = next.expectsMark.ignore;
    }
  }

  if (this.ignoreCmdCode === response.code) {
    this.ignoreCmdCode = null;
    return;
  }

  this.parse(response, this.commandQueue.shift());
};

Ftp.prototype.send = function(command) {
  if (!command) return;

  dbgCommand(command);
  this.pipeline.write(command + '\r\n');
};

Ftp.prototype.nextCmd = function() {
  if (!this.inProgress && this.commandQueue[0]) {
    this.send(this.commandQueue[0].action);
    this.inProgress = true;
  }
};

Ftp.prototype.execute = function(action, callback) {
  if (this.socket && this.socket.writable) {
    return this.runCommand(action, callback || NOOP);
  }

  var self = this;
  this.authenticated = false;
  this._createSocket(this.port, this.host, function() {
    self.runCommand(action, callback || NOOP);
  });
};

Ftp.prototype.runCommand = function(action, callback) {
  var cmd = {
    action: action,
    callback: callback
  };

  if (this.authenticated || /feat|syst|user|pass/.test(action)) {
    this.commandQueue.push(cmd);
    this.nextCmd();
    return;
  }

  var self = this;
  this.getFeatures(function() {
    self.auth(self.user, self.pass, function() {
      self.commandQueue.push(cmd);
      self.nextCmd();
    });
  });
};

Ftp.prototype.parse = function(response, command) {
  var err = null;
  if (response.isError) {
    err = new Error(response.text || 'Unknown FTP error.');
    err.code = response.code;
  }

  command.callback(err, response);
  this.inProgress = false;
  this.nextCmd();
};


Ftp.prototype.hasFeat = function(feature) {
  return !!feature && this.features.indexOf(feature.toLowerCase()) > -1;
};


Ftp.prototype._parseFeats = function(features) {
  var featureLines = features.split(FTP_NEWLINE).slice(1, -1);
  return featureLines
    .map(function(feat) { return feat.trim().toLowerCase(); })
    .filter(function(feat) { return !!feat; });
};


Ftp.prototype.getFeatures = function(callback) {
  if (this.features) {
    return callback(null, this.features);
  }

  var self = this;
  this.raw.feat(function(err, response) {
    self.features = err ? [] : self._parseFeats(response.text);
    self.raw.syst(function(err, res) {
      if (!err && res.code === 215) {
        self.system = res.text.toLowerCase();
      }

      callback(null, self.features);
    });
  });
};


Ftp.prototype.auth = function(user, pass, callback) {
  var self = this;

  if (this.authenticating === true) {
    return callback(new Error('This client is already authenticating'));
  }

  if (!user) user = 'anonymous';
  if (!pass) pass = '@anonymous';

  this.authenticating = true;
  self.raw.user(user, function(err, res) {
    if (err || [230, 331, 332].indexOf(res.code) === -1) {
      self.authenticating = false;
      callback(err);
      return;
    }

    self.raw.pass(pass, function(err, res) {
      self.authenticating = false;

      if (err) {
        callback(err);
      } else if ([230, 202].indexOf(res.code) > -1) {
        self.authenticated = true;
        self.user = user;
        self.pass = pass;
        self.raw.type('I', function() {
          callback(undefined, res);
        });
      } else if (res.code === 332) {
        self.raw.acct(''); // ACCT not really supported
      }
    });
  });
};

Ftp.prototype.setType = function(type, callback) {
  type = type.toUpperCase();
  if (this.type === type) {
    return callback();
  }

  var self = this;
  this.raw.type(type, function(err, data) {
    if (!err) self.type = type;

    callback(err, data);
  });
};


Ftp.prototype.list = function(path, callback) {
  if (arguments.length === 1) {
    callback = arguments[0];
    path = '';
  }

  var self = this;
  var listing = '';
  callback = once(callback);

    self.getPasvSocket(function(err, socket) {
      if (err) return callback(err);

      socket.setEncoding('utf8');
      socket.on('data', function(data) {
        listing += data;
      });

      self.pasvTimeout.call(self, socket, callback);

      socket.once('close', function(err) { callback(err, listing); });
      socket.once('error', callback);

      function cmdCallback(err, res) {
        if (err) return callback(err);

        var isExpectedMark = expectedMarks.marks.some(function(mark) {
          return mark === res.code;
        });

        if (!isExpectedMark) {
          callback(new Error(
            'Expected marks ' + expectedMarks.toString() + ' instead of: ' +
            res.text));
        }
      }

      cmdCallback.expectsMark = expectedMarks;

      self.execute('list ' + (path || ''), cmdCallback);
    });
};

Ftp.prototype.emitProgress = function(data) {
  this.emit('progress', {
    filename: data.filename,
    action: data.action,
    total: data.totalSize || 0,
    transferred: data.socket[
      data.action === 'get' ? 'bytesRead' : 'bytesWritten']
  });
};

Ftp.prototype.get = function(remotePath, localPath, callback) {
  var self = this;
  var finalCallback;

  if (typeof localPath === 'function') {
    finalCallback = once(localPath || NOOP);
  } else {
    callback = once(callback || NOOP);
    finalCallback = function(err, socket) {
      if (err) {
        return callback(err);
      }

      var writeStream = fs.createWriteStream(localPath);
      writeStream.on('error', callback);

      socket.on('readable', function() {
        self.emitProgress({
          filename: remotePath,
          action: 'get',
          socket: socket
        });
      });


      socket.on('error', callback);
      socket.on('end', callback);
      socket.on('close', callback);

      socket.pipe(writeStream);
      socket.resume();
    };
  }

  this.getGetSocket(remotePath, finalCallback);
};


Ftp.prototype.getGetSocket = function(path, callback) {
  var self = this;
  callback = once(callback);
  this.getPasvSocket(function(err, socket) {
    if (err) return cmdCallback(err);

    socket.on('error', function(err) {
      if (err.code === 'ECONNREFUSED') {
        err.msg = 'Probably trying a PASV operation while one is in progress';
      }
      cmdCallback(err);
    });

    self.pasvTimeout.call(self, socket, cmdCallback);
    socket.pause();

    function cmdCallback(err, res) {
      if (err) {
        return callback(err);
      }

      if (!socket) {
        return callback(new Error('Error when retrieving PASV socket'));
      }

      if (res.code === 125 || res.code === 150) {
        return callback(null, socket);
      }

      return callback(new Error('Unexpected command ' + res.text));
    }

    cmdCallback.expectsMark = expectedMarks;
    self.execute('retr ' + path, cmdCallback);
  });
};

Ftp.prototype.put = function(from, to, callback) {
  var self = this;

  function putReadable(from, to, totalSize, callback) {
    from.on('readable', function() {
      self.emitProgress({
        filename: to,
        action: 'put',
        socket: from,
        totalSize: totalSize
      });
    });

    self.getPutSocket(to, function(err, socket) {
      if (err) return;
      from.pipe(socket);
    }, callback);
  }

  if (from instanceof Buffer) {
    this.getPutSocket(to, function(err, socket) {
      if (!err) socket.end(from);
    }, callback);
  } else if (typeof from === 'string') {
    fs.stat(from, function(err, stats) {
      if (err && err.code === 'ENOENT') {
        return callback(new Error('Local file doesn\'t exist.'));
      }

      if (stats.isDirectory()) {
        return callback(new Error('Local path cannot be a directory'));
      }

      var totalSize = err ? 0 : stats.size;
      var localFileStream = fs.createReadStream(from, {
        bufferSize: 4 * 1024
      });
      putReadable(localFileStream, to, totalSize, callback);
    });
  } else { // `from` is a readable stream
    putReadable(from, to, from.size, callback);
  }
};

Ftp.prototype.getPutSocket = function(path, callback, doneCallback) {
  if (!callback) {
    throw new Error('A callback argument is required.');
  }

  doneCallback = once(doneCallback || NOOP);
  var _callback = once(function(err, _socket) {
    if (err) {
      callback(err);
      return doneCallback(err);
    }
    return callback(null, _socket);
  });

  var self = this;
  this.getPasvSocket(function(err, socket) {
    if (err) return _callback(err);
    socket.on('close', doneCallback);
    socket.on('error', doneCallback);

    var putCallback = once(function putCallback(err, res) {
      if (err) return _callback(err);

      // Mark 150 indicates that the 'STOR' socket is ready to receive data.
      // Anything else is not relevant.
      if (res.code === 125 || res.code === 150) {
        self.pasvTimeout.call(self, socket, doneCallback);
        return _callback(null, socket);
      }

      return _callback(new Error('Unexpected command ' + res.text));
    });

    putCallback.expectsMark = expectedMarks;

    self.execute('stor ' + path, putCallback);
  });
};

Ftp.prototype.pasvTimeout = function(socket, cb) {
  var self = this;
  socket.once('timeout', function() {
    debug('PASV socket timeout');
    self.emit('timeout');
    socket.end();
    cb(new Error('Passive socket timeout'));
  });
};

Ftp.prototype.getPasvSocket = function(callback) {
  var self = this;
  callback = once(callback || NOOP);

  this.execute('pasv', function(err, res) {
    if (err) return callback(err);

    getPasvPort(res.text, function(err, options) {
      if (err) return callback(err);

      var socket = self._pasvSocket = Net.createConnection(options);
      socket.setTimeout(self.timeout || TIMEOUT);
      socket.once('connect', function() {
        self._pasvSocket = socket;
      });
      socket.once('close', function() {
        self._pasvSocket = undefined;
      });

      callback(null, socket);
    });
  });
};


Ftp.prototype.ls = function(filePath, callback) {
  function entriesToList(err, entries) {
    if (err) return callback(err);

    ListingParser.parseFtpEntries(entries.text || entries, function(err, files) {
          if (err) return callback(err);

          files.forEach(function(file) {
            // Normalize UTF8 doing canonical decomposition, followed by
            // canonical Composition
            file.name = unorm.nfc(file.name);
          });
          callback(null, files);
      });
  }
  console.log('ls');
    this.list(filePath, entriesToList);
    
};

Ftp.prototype.rename = function(from, to, callback) {
  var self = this;
  this.raw.rnfr(from, function(err) {
    if (err) return callback(err);

    self.raw.rnto(to, function(err, res) {
      callback(err, res);
    });
  });
};

Ftp.prototype.keepAlive = function(wait) {
  var self = this;
  if (this._keepAliveInterval) {
    clearInterval(this._keepAliveInterval);
  }

  this._keepAliveInterval = setInterval(self.raw.noop, wait || IDLE_TIME);
};

Ftp.prototype.destroy = function() {
  if (this._keepAliveInterval) {
    clearInterval(this._keepAliveInterval);
  }

  if (this.socket && this.socket.writable) {
    this.socket.end();
  }

  if (this._pasvSocket && this._pasvSocket.writable) {
    this._pasvSocket.end();
  }

  this.resParser.end();

  this.socket = undefined;
  this._pasvSocket = undefined;

  this.features = null;
  this.authenticated = false;
};

module.exports = Ftp;