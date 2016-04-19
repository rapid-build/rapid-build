var path   = require('path'),
	rbRoot = path.resolve(__dirname, '..', '..', '..'),
	msg    = 'Do you need to build prod before you commit?',
	skip   = 'Skip this by adding --no-verify.',
	sep    = ('-').repeat(msg.length);

require('coffee-script/register');
require(`${rbRoot}/extra/tasks/add-colors`)();

/* Message
 **********/
console.log(sep.attn);
console.log(msg.attn);
console.log(skip.attn);
console.log(sep.attn);

/* Exit the Commit
 ******************/
process.exit(1);