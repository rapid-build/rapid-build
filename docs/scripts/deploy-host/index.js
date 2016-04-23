require('coffee-script/register');

var path     = require('path'),
	docsRoot = path.resolve(__dirname, '..', '..'),
	helpers  = path.join(docsRoot, 'scripts', 'helpers'),
	pkgPath  = path.join(docsRoot, 'package.json'), // docs package.json
	pkg      = require(pkgPath),
	location = process.argv.slice(2)[0], // master or latest tag
	location = location == 'tag' ? `v${pkg.version}` : location,
	location = 'v0.1.6',
	deploy   = require('./deploy'),
	needle   = 'unexpected error', // random gandi error at beginning of deploy
	cnt      = 1,
	runDeploy;

/* Helpers
 **********/
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Deploy Docs
 **************/
runDeploy = () => {
	var msg = '';
	return deploy(docsRoot, location).then(result => {
		if (cnt == 5) {
			msg = `Docs Deployment Failed from ${location}. ${needle}`;
			return log(msg, 'error');
		} else if (result.indexOf('Aborting deployment') != -1) {
			console.log(result);
			msg = `Docs Deployment Failed from ${location}`;
			return log(msg, 'error');
		} else if (result.indexOf(needle) != -1) {
			cnt++;
			log(`Redeploy CNT ${cnt}`);
			console.log(result);
			return runDeploy();
		}
		console.log(result);
		log(`Docs Deployed from ${location}`);
	}).catch(e => {
		msg = `Docs Deployment Failed from ${location}`;
		log(msg, 'error');
		console.error(`Error: ${e.message}`.error);
	});
};

/* RUN IT!
 **********/
runDeploy();