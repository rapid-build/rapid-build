require('coffee-script/register');
var argv     = process.argv.slice(2)[0],       // ci | master | latest
	deployer = argv == 'ci' ? 'ci' : 'local',  // ci | local
	deploy   = argv == 'ci' ? 'latest' : argv, // master | latest
	dir      = __dirname,
	path     = require('path'),
	docsRoot = path.resolve(dir, '..', '..'),
	version  = require(path.join(docsRoot, 'package.json')).version; // docs version

deploy = deploy == 'latest' ? `v${version}` : 'master';
// deploy = deploy == 'latest' ? 'v0.1.0' : 'master';

/* Change Working Dir
 *********************/
process.chdir(docsRoot);

/* Helpers
 **********/
var helpers = path.join(docsRoot, 'scripts', 'helpers');
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Deploy Docs
 **************/
var deployDocs = require(`${dir}/deploy`);
deployDocs(docsRoot, deployer, deploy).then(res => {
	log('Docs Deployed');
	if (!res || typeof res != 'string') return
	console.log(res.attn);
}).catch(e => {
	log('Failed to Deploy Docs', 'error');
	if (!e || typeof e != 'string') return
	console.log(e.error)
});