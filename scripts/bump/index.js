var bump;
var rbRoot = process.cwd();
var version = process.argv.slice(2)[0];

require('coffeescript/register');
require(`${rbRoot}/extra/tasks/add-colors`)();
bump = require('./bump');

/* BUMP PACKAGE(S) VERSION
 **************************/
bump(rbRoot, version)
.then(() => {
	console.log('BUMPED PACKAGES'.attn);
})
.catch(e => {
	console.error('BUMPED FAILED'.error);
	console.error(`Error: ${e.message}`.error);
})