require('coffee-script/register');

var dir      = __dirname,
	path     = require('path'),
	docsRoot = path.resolve(dir, '..', '..');

/* Change Working Dir
 *********************/
process.chdir(docsRoot);

/* Helpers
 **********/
var helpers  = path.join(docsRoot, 'scripts', 'helpers');
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Tasks
 ********/
var runTasks = require(`${dir}/run-tasks`);
runTasks(docsRoot).then(res => {
	log('Docs Deployed');
	if (!res || typeof res != 'string') return
	console.log(res.attn);
}).catch(e => {
	log('Failed to Deploy Docs', 'error');
	if (!e || typeof e != 'string') return
	console.log(e.error)
});