'use strict'

/* Requires
 ***********/
var path = require('path'),
	gulp = require('gulp');

/* Vars
 *******/
var getBuildMode, getIsCiBuild;
var buildMode, isCiBuild, options;
var buildPath, config;
var buildTask, gulpTask;

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

/* Init Config
 **************/
buildPath = path.resolve(__dirname, '../..');
config    = { pkgs: { rb: {} } };
try {
	config = require(buildPath + '/temp/config.json'); // npm test creates this file (see /test/init/index.coffee)
} catch (e) {
	console.log(e.message);
	config.pkgs.rb = require(buildPath + '/package.json');
}

/* Init Build
 *************/
buildMode = getBuildMode(process.argv[2]);
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3]);
options   = require('./build-options')(buildMode, isCiBuild);
require(buildPath)(gulp, options);

/* Init Tasks
 *************/
gulpTask  = buildMode;
buildTask = config.pkgs.rb.name;
if (gulpTask && gulpTask != 'default') buildTask += `:${buildMode}`;
// console.log('TASKS ---', gulpTask, buildTask);
if (!!gulp.tasks[gulpTask]) return

/**
 * Run Build - in the console type one of the following:
 * gulp
 * gulp test | test:client | test:server
 * gulp dev  | dev:test    | dev:test:client  | dev:test:server
 * gulp prod | prod:test   | prod:test:client | prod:test:server | prod:server
 ******************************************************************************/
gulp.task('default', [config.pkgs.rb.name], function(cb) {
	console.log('Build Complete!');
	cb();
})

gulp.task(gulpTask, [buildTask], function(cb) {
	console.log('Build Complete!');
	cb();
})


