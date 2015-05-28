/**
 * init rapid-build
 * arguments are: gulp and options
 * argument order does not matter
 * pass in gulp if your app is using gulp
 * options are optional
 */
module.exports = function() {
	var gulp, options;

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

	require('coffee-script/register')
	return require('./gulpfile.coffee')(gulp, options)
}