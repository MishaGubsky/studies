var PORT = 33333;
var HOST = '127.0.0.1';

var dgram = require('dgram');
var server = dgram.createSocket({reuseAddr: true, type:'udp4'});

var clients = [];
var name_clients = [];


server.on('message', function (message, remote) {
	var clientId = remote.address + ':' + remote.port;
	if (message.toString() == 'exit'){
		delete(clients[clientId]);
		delete(name_clients[clientId]);
		console.log( remote.address + ':' + remote.port + ' - ' + 'disconnected' );
	}else{
	    if (!clients[clientId]) {
	    	clients[clientId] = remote;
	    	name_clients[clientId] = message;
	    	console.log( remote.address + ':' + remote.port + ' - ' + 'connected' );
	    }
	    else{
	    	for (var client in clients) {
		    	if (client !== clientId) {
		    		client = clients[client];
		    		ms = name_clients[clientId] + '> ' + message;
		    		server.send(ms, 0, ms.length, client.port, client.address );
		    	}
		    }
		   	console.log( remote.address + ':' + remote.port + ' - ' + message );

		}
	}
    
});

server.bind(PORT, HOST);