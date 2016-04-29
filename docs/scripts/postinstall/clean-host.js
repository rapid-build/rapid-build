require('coffee-script/register');
var dir      = __dirname,
	path     = require('path'),
	docsRoot = path.resolve(dir, '..', '..');

/* Helpers
 **********/
var helpers = path.join(docsRoot, 'scripts', 'helpers');
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* postinstall
 **************/
var postinstall = require(`${dir}/tasks/clean-host`);
postinstall(docsRoot).then(res => {
	if (!res || typeof res != 'string') return
	console.log(res.attn);
}).catch(e => {
	if (!e || typeof e.message != 'string') return
	console.log(e.message.error)
})