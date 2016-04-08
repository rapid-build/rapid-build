'use strict'

/* Vars
 *******/
var getBuildMode, getIsCiBuild;
var build, buildMode, isCiBuild, options;

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
buildMode = getBuildMode(process.argv[2])
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3])
options   = require('./build-options')(buildMode, isCiBuild)
build     = require('build-buddy')(options)

/**
 * Run Build - in the console type one of the following:
 * node build
 * node build test
 * node build test:client
 * node build test:server
 * node build dev
 * node build dev:test
 * node build dev:test:client
 * node build dev:test:server
 * node build prod
 * node build prod:server
 * node build prod:test
 * node build prod:test:client
 * node build prod:test:server
 ******************************************************/
build(buildMode).then(() => {
	console.log('Build Complete!')
})
