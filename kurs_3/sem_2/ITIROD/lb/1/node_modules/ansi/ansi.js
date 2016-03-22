// http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes

"use strict";

var
    util = require('util'),
    out = process.stdout;

var
    CSI = '\x1B[';

function esc(param) {
    return CSI + param;
}

function Ansi() {

    if (!out.isTTY) {
        throw new Error('stdout is not TTY');
    }
}

Ansi.prototype = {

    row: function (num) {

        return this.move(num);
    },

    col: function (num) {
        var
            cmd;

        if ((typeof num == 'number') && (num != 0)) {

            if (num < 0) {
                num = out.columns + (num + 1);
            }

            cmd = util.format('%dG', num);

            out.write(esc(cmd));

        } else {

            throw new Error('Invalid column ' + num);
        }

        return this;
    },

    move: function (row, col) {
        var
            cmd;

        if (typeof row != 'number') {
            throw new Error('Invalid row');
        }

        if (typeof col != 'number') {

            if (typeof col != 'undefined') {
                throw new Error('Invalid column');
            }

            col = 1;
        }

        cmd = util.format('%d;%df', row, col);

        out.write(esc(cmd));

        return this;
    },

    print: function (params) {
        var
            str = util.format.apply(null, arguments);

        out.write(str);

        return this;
    },

    clearLine: function () {

        out.write(esc('2K'));

        return this;
    },

    clear: function (lineNum) {

        if (typeof lineNum == 'number') {

            this.move(lineNum);
            out.write(esc('2K'));

        } else if (typeof lineNum == 'undefined') {

            out.write(esc('2J'));

        } else {

            throw new Error('Invalid argument ' + lineNum);
        }

        return this;
    }
};

module.exports = new Ansi();
