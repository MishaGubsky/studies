var host = "127.0.0.1", port = 33334;

var dgram = require( "dgram" );
var client = dgram.createSocket({reuseAddr: true, type:'udp4'});
var readline = require('readline');
var rl = readline.createInterface(process.stdin, process.stdout);
var ansi = require('ansi');
var name = '';


ansi.clear();

ansi.row(40);
rl.setPrompt('\nEnter your name> ');
rl.prompt();

rl.on('line', (line)=>{
	ansi.row(37);

	client.send(line, 0, line.length, 33333, "127.0.0.1" );
	if (line == 'exit'){
		exit();
	}else{
		input();
	}
}).on('close',()=>{
	ansi.row(37);
	client.send('exit', 0, 4, 33333, "127.0.0.1" );
	exit();
});

function exit(){
	setTimeout(() => {
			console.log('Goodbay!');
			client.close();
			process.exit();
		}, 100);
}


function input(){
		ansi.row(40);
		rl.setPrompt('\nMe> ');
		rl.prompt();
	}

client.on("message", function( msg, rinfo ) {
		ansi.row(37);
    	console.log( msg.toString() +'\n');
    	input();
});


client.bind(host);