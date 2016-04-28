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
var postinstall = require(`${dir}/postinstall`);
postinstall(docsRoot).then(res => {
	log('Installed Docs');
	if (!res || typeof res != 'string') return
	console.log(res.attn);
}).catch(e => {
	log('Failed to Install Docs', 'error');
	if (!e || typeof e != 'string') return
	console.log(e.error)
});