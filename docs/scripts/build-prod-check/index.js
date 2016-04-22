require('coffee-script/register');

var path     = require('path'),
	docsRoot = path.resolve(__dirname, '..', '..'),
	helpers  = path.join(docsRoot, 'scripts', 'helpers');

/* Helpers
 **********/
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Message
 **********/
var msg =  'Do you need to build prod before you commit?\n';
	msg += 'Skip this by adding --no-verify.';

/* Exit the Commit
 ******************/
log(msg);
process.exit(1);