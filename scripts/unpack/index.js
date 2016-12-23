var unpackServerPkgs;
var fs       = require('fs');
var rbRoot   = process.cwd();
var unpacked = true;
require('coffee-script/register');
require(`${rbRoot}/extra/tasks/add-colors`)();

/* node_modules check
 *********************/
try { fs.lstatSync(`${rbRoot}/lib/src/server/node_modules/`).isDirectory() }
catch (e) { unpacked = false; }

if (unpacked)
	return console.log('Skipped Upacking Web Server Packages (already unpacked).'.attn);

/* UNPACK SERVER PKGS
 *********************/
unpackServerPkgs = require('./unpack-server-pkgs');
unpackServerPkgs(rbRoot)
.then(() => {
	console.log('UNPACKED WEB SERVER PACKAGES'.attn);
})
.catch(e => {
	console.error('FAILED TO UNPACKED WEB SERVER PACKAGES'.error);
	console.error(`Error: ${e.message}`.error);
})