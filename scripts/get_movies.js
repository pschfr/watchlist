// Import and declare stuff
const {spawn} = require('child_process');
var dataToSend;

// Spawn new child process to call the Python script
const python3 = spawn('python3', ['scripts/get_movies.py']);

// On receiving data, do this...
python3.stdout.on('data', function(data) {
	dataToSend = data.toString();
	console.log(`Loading data from python3 script...\n\n${dataToSend}`)
});

// If it errors, let me know
python3.stderr.on('data', (data) => {
	console.error(`stderr: ${data}`);
});

// Fires on closing the process
python3.on('close', (code) => {
	// console.log(`Child process close all stdio with code ${code}`);
});
