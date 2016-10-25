#! /usr/bin/env node
var path = require('path');

/* Constants
 ************/
const BIN_PATH   = __dirname;
const BUILD_PATH = path.join(BIN_PATH, '..');
const DIST_PATH  = path.join(BUILD_PATH, 'dist');
var build        = require(DIST_PATH);

/* Helpers
 **********/
var logBuildMsg = (msg, type, results) => {
	var div = Array(msg.length+1).join('-'),
		isE = type === 'error';
		msg = `\n${msg}\n`;
	console.log(msg[type]);

	if (!isE) return // comment out to see results

	if (!results) return
	results = results instanceof Error ? results : JSON.stringify(results, null, '\t');
	type    = type === 'error' ? 'error' : 'log';
	console[type](results)
	console.log('\n')
}

/* Run Build (returns promise)
 * Run one of the following in the terminal:
 * build
 * build test | test:client | test:server
 * build dev  | dev:test    | dev:test:client  | dev:test:server
 * build prod | prod:test   | prod:test:client | prod:test:server | prod:server
 *******************************************************************************/
return build()
.then((results) => {
	logBuildMsg('Build Complete!', 'attn', results);
})
.catch((error) => {
	logBuildMsg('Build Failed', 'error', error);
});;