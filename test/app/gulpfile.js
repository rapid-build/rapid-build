'use strict'

/* Requires
 ***********/
var path = require('path'),
	gulp = require('gulp');

/* Vars
 *******/
var getBuildMode, getIsCiBuild;
var buildMode, isCiBuild, options;
var buildPath;

/* Helpers
 **********/
getBuildMode = (_buildMode) => { // return string
	if (typeof _buildMode !== 'string') return 'default'
	_buildMode = _buildMode.toLowerCase()
	if (_buildMode === 'ci') return 'default'
	return _buildMode
}
getIsCiBuild = (_buildMode, _ciBuildMode) => { // return boolean
	if (_buildMode === 'ci') return true
	if (typeof _ciBuildMode !== 'string') return false
	return _ciBuildMode.toLowerCase() === 'ci'
}

/* Init Build
 *************/
buildPath = path.resolve(__dirname, '../..');
buildMode = getBuildMode(process.argv[2]);
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3]);
options   = require('./build-options')(buildMode, isCiBuild);
require(buildPath)(gulp, options);

/**
 * Run Build - in the console type one of the following:
 * gulp
 * gulp test
 * gulp test:client
 * gulp test:server
 * gulp dev
 * gulp dev:test
 * gulp dev:test:client
 * gulp dev:test:server
 * gulp prod
 * gulp prod:server
 * gulp prod:test
 * gulp prod:test:client
 * gulp prod:test:server
 ******************************************************/
gulp.task('default', ['rapid-build'], function(cb) {
	console.log('Build Complete!');
	cb();
})