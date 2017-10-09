/* PACKAGE ENTRY SCRIPT
 * package.json's main field value
 * arguments are: gulp and options
 * argument order does not matter
 * pass in gulp if your app is using gulp
 * options are optional
 *****************************************/
module.exports = function() {
	var rbRoot  = __dirname,
		path    = require('path'),
		lib     = process.env.RB_LIB === 'src' ? 'src' : 'lib',
		libPath = path.join(rbRoot, lib);

	/* get gulp and options
	 ***********************/
	var gulp, options;
	if (arguments.length) {
		var getGulp = function(args) {
			if (!!args[0].task) return args[0]
			else if (!!args[1] && !!args[1].task) return args[1]
		}
		var getOptions = function(args) {
			if (!args[0].task) return args[0]
			else if (!!args[1] && !args[1].task) return args[1]
		}
		gulp    = getGulp(arguments)
		options = getOptions(arguments)
	}

	/* helper
	 *********/
	var getLib = function() {
		return require(libPath)(gulp, options);
	}

	/* for testing src
	 ******************/
	if (lib === 'src') {
		// console.log('LIB IS SRC');
		return getLib();
	}

	/* has lib been created?
	 ************************/
	var hasLib = false;
	try { hasLib = require('fs').statSync(libPath).isDirectory(); }
	catch(e) {}

	if (hasLib) {
		// console.log('LIB IS THERE');
		return getLib();
	}

	/* no lib so create it
	 **********************/
	var opts   = { cwd: rbRoot },
		stdout = require('child_process').execSync('npm run create-lib', opts);

	console.log(stdout.toString());

	/* get lib
	 **********/
	return getLib();
}