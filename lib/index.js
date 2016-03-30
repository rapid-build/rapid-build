/**
 * init the build
 * arguments are: gulp and options
 * argument order does not matter
 * pass in gulp if your app is using gulp
 * options are optional
 */
module.exports = function() {
	var gulp, options;
	var isLib, path, parentDir;

	path      = require('path');
	parentDir = path.basename(__dirname); // src or lib
	isLib     = parentDir == 'lib';

	if (arguments.length) {
		var getGulp = function(args) {
			if (!!args[0].seq) return args[0]
			else if (!!args[1] && !!args[1].seq) return args[1]
		}
		var getOptions = function(args) {
			if (!args[0].seq) return args[0]
			else if (!!args[1] && !args[1].seq) return args[1]
		}
		gulp    = getGulp(arguments)
		options = getOptions(arguments)
	}

	if (!isLib) require('coffee-script/register');
	return require('./gulpfile')(gulp, options)
}