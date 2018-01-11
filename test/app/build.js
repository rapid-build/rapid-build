'use strict'
require('coffeescript/register');

/* Requires
 ***********/
var path = require('path');

/* Vars
 *******/
var getBuildMode, getIsCiBuild;
var build, buildMode, isCiBuild, options;
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
buildMode = getBuildMode(process.argv[2])
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3])
options   = require('./build-options')(buildMode, isCiBuild)
build     = require(buildPath)(options)

/**
 * Run Build - in the console type one of the following:
 * node build
 * node build test | test:client | test:server
 * node build dev  | dev:test    | dev:test:client  | dev:test:server
 * node build prod | prod:test   | prod:test:client | prod:test:server | prod:server
 ************************************************************************************/
build(buildMode).then(() => {
	console.log('Build Complete!')
})
