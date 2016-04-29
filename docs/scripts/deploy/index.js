require('coffee-script/register');
var args     = process.argv.slice(2),
	dir      = __dirname,
	path     = require('path'),
	docsRoot = path.resolve(dir, '..', '..'),
	pkg      = require(path.join(docsRoot, 'package.json')); // docs pkg

/* Change Working Dir
 *********************/
process.chdir(docsRoot);

/* Helpers
 **********/
var helpers = path.join(docsRoot, 'scripts', 'helpers');
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Set Deployment Args
 **********************/
var deployer = args[0],
	deploy   = args[1],
	tagName  = args[2],
	tag      = args[3],
	build    = false;

deployer = deployer == 'ci' ? 'ci' : 'local';
tagName  = tagName == 'latest' ? `v${pkg.version}` : tagName;
tag      = tag == 'true';

switch (deployer) {
	case 'ci':
		deploy = `v${pkg.version}`;
		tag    = true;
		break;
	case 'local':
		switch (deploy) {
			case 'master':
				tag   = false;
				build = true;
				break;
			case 'tag':
				deploy = tagName;
				if (!deploy || deploy.length < 2 ||
					(deploy.indexOf('v') != 0 && deploy != 'master')
				   ) {
					log('Failed to Deploy Docs', 'error');
					console.log(`Invalid Tag: ${deploy}`.error);
					process.exit();
				}
				break;
		}
		break;
	default:
		log('Failed to Deploy Docs', 'error');
		console.log('Deployer was not Specified'.error);
		process.exit();
}

/* Deploy Docs
 **************/
var deployDocs = require(`${dir}/deploy`);
deployDocs(docsRoot, deployer, deploy, build, tag).then(res => {
	log('Docs Deployed');
	if (!res || typeof res != 'string') return
	console.log(res.attn);
}).catch(e => {
	log('Failed to Deploy Docs', 'error');
	if (!e || typeof e != 'string') return
	console.log(e.error)
});