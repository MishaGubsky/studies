var PORT = 33333;
var HOST = '127.0.0.1';

var dgram = require('dgram');
var client = dgram.createSocket('udp4');
var readline = require('readline');
var name = readline.createInterface(process.stdin, process.stdout);
var message = readline.createInterface(process.stdin, process.stdout);

name.setPrompt('Your Name> ');
name.prompt();
name.on('line', (line)=>{
	sendData(line);
}).on('close', ()=>{
	process.exir(0);
});

client.on('name', (message, remote)=>{
	console.log('${name.toString()}');
	message.prompt();
});

client.send(new Buffer(name.toString()), 0, name.length, PORT, HOST);


message.setPrompt('Me> ');
message.prompt();
message.on('line', (line)=>{
	sendData(line);
}).on('close', ()=>{
	process.exir(0);
});

client.on('message', (message, remote)=>{
	console.log('<${name.toString()} ${message.toString()}');
	message.prompt();
});


function sendData(m){
	client.send(new Buffer(m), 0, m.length, PORT, HOST, (err,bytes)=> {
    				console.log('Send:', m);
    				message.prompt();
    			});
}






var PORT = 33333;
var HOST = '127.0.0.1';

var dgram = require('dgram');
var server = dgram.createSocket({reuseAddr: true, type:'udp4'});

var clients = [];

// server.on('listening', function () {
//     var address = server.address();
//     console.log('UDP Server listening on ' + address.address + ":" + address.port);
// });

server.on( "message", function( msg, rinfo ) {
    console.log( rinfo.address + ':' + rinfo.port + ' - ' + msg );
    server.send( msg, 0, msg.length, rinfo.port, rinfo.address ); // added missing bracket
});

server.bind(PORT, HOST);