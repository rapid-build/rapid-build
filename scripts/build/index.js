/* BUILD ENTRY
 **************/
require('ts-node/register')
require('./bootstrap')
var Build = require('./Build').default

console.log('index');

Build.run()
.then(() => {
	console.log('PACKAGE DIST CREATED'.attn);
})
.catch(e => {
	console.error('FAILED TO CREATE PACKAGE DIST'.error);
	console.error(`Error: ${e.message}`.error);
})