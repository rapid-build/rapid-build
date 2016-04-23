require('coffee-script/register');

var path     = require('path'),
	async    = require('asyncawait/async'),
	await    = require('asyncawait/await'),
	dir      = __dirname,
	docsRoot = path.resolve(dir, '..', '..'),
	helpers  = path.join(docsRoot, 'scripts', 'helpers');

/* Change Working Dir
 *********************/
process.chdir(docsRoot);

/* Helpers
 **********/
require(`${helpers}/add-colors`)();
var log = require(`${helpers}/log`);

/* Tasks
 ********/
var decryptKey          = require(`${dir}/decrypt-deploy-key`),
	disableHostKeyCheck = require(`${dir}/disable-host-key-check`);


/* Run Tasks
 ************/
var runTasks = async(() => {
	await(decryptKey(docsRoot));
	// await(disableHostKeyCheck(docsRoot));
	log('Docs Deployed');
});

/* Init
 *******/
runTasks();