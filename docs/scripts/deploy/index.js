require('coffee-script/register');

var path     = require('path'),
	rbRoot   = path.resolve(__dirname, '..', '..', '..'),
	pkgPath  = path.resolve(__dirname, '..', '..', 'package.json'),
	pkg      = require(pkgPath),
	version  = pkg.version,
	location = process.argv.slice(2)[0], // master or latest tag
	location = location == 'tag' ? `v${version}` : location,
	location = 'v0.1.5',
	deploy   = require('./deploy'),
	needle   = 'unexpected error', // random gandi error at beginning of deploy
	cnt      = 1,
	log,
	runDeploy;

/* Helpers
 **********/
require(`${rbRoot}/extra/tasks/add-colors`)();

log = (msg, type) => {
	type = type || 'attn';
	var sep    = '-'.repeat(msg.length),
		method = type == 'attn' ? 'log' : type;
	console[method](sep[type]);
	console[method](msg[type]);
	console[method](sep[type]);
};

/* Deploy Docs
 **************/
runDeploy = () => {
	var msg = '';
	return deploy(location).then(result => {
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