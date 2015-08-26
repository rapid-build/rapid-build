/**
 * Ensure bower_components dir gets removed before publishing to npm.
 * .npmignore is not enough because some bower packages
 * contain: package.json and/or README.md
 * and these files never get ignored.
 **********************************************************************/
var bowerPath, cwd, fse, logMsg, path, q;

q         = require('q')
path      = require('path')
fse       = require('fs-extra')
logMsg    = require('./helpers/log-msg')
cwd       = process.cwd()
bowerPath = path.join(cwd, 'src', 'client', 'bower_components'); // ; required

/**
 * Init
 */
(function() {
	var defer = q.defer()
	logMsg('npm prepublish')
	fse.remove(bowerPath, function(e) {
		if (e) return console.log(e)
		console.log('removed bower_components directory')
		return defer.resolve()
	})
	return defer.promise
})()