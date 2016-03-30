var createLib;
var rbRoot = process.cwd();

require('coffee-script/register');
require(`${rbRoot}/extra/tasks/add-colors`)();
createLib = require('./create-lib');

/* CREATE LIB
 *************/
createLib(rbRoot)
.then(() => {
	console.log('PACKAGE LIB CREATED'.attn);
})
.catch(e => {
	console.error('FAILED TO CREATE PACKAGE LIB'.error);
	console.error(`Error: ${e.message}`.error);
})