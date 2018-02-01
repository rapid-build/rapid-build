'use strict'
require('coffeescript/register');

/* Requires
 ***********/
var path = require('path'),
	gulp = require('gulp');

/* Vars
 *******/
var getBuildMode, getIsCiBuild, getConfig;
var buildMode, isCiBuild, options;
var buildPath, config;
var gulpTask, gulpTaskOrg;
var buildTask, buildTaskPrefix;

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
getConfig = () => {
	if (process.env.RB_TEST) {
		config = require(buildPath + '/extra/temp/config.json'); // npm test creates this file (see /test/init/index.coffee)
	} else {
		config = { pkgs: { rb: {} } };
		config.pkgs.rb = require(buildPath + '/package.json');
	}
	return config;
}

/* Init Config
 **************/
buildPath = path.resolve(__dirname, '../..');
config    = getConfig();

/* Init Build
 *************/
buildMode = getBuildMode(process.argv[2]);
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3]);
options   = require('./build-options')(buildMode, isCiBuild);
require(buildPath)(gulp, options);

/* Init Tasks
 *************/
gulpTask        = buildMode;
gulpTaskOrg     = gulpTask;
buildTask       = config.pkgs.rb.name;
buildTaskPrefix = config.pkgs.rb.build.tasksPrefix;

// if (gulpTask && gulpTask != 'default') buildTask += `:${buildMode}`;
if (gulpTask && gulpTask.indexOf(buildTaskPrefix) !== -1) {
	gulpTask  = `${buildTask}:${gulpTask}`
	buildTask = gulpTaskOrg;
} else if (gulpTask && gulpTask != 'default') {
	buildTask += `:${buildMode}`;
}

// console.log('APP TASKS:', { gulpTask, buildTask}, '\n');
if (!!gulp.tree().nodes[gulpTask]) return

/**
 * Run Build - in the console type one of the following:
 * gulp
 * gulp test | test:client | test:server
 * gulp dev  | dev:test    | dev:test:client  | dev:test:server
 * gulp prod | prod:test   | prod:test:client | prod:test:server | prod:server
 ******************************************************************************/
gulp.task('default', gulp.series([
	config.pkgs.rb.name,
	function(done) {
		console.log('Build Complete!');
		done();
	}
]));

gulp.task(gulpTask, gulp.series([
	buildTask,
	function(done) {
		console.log('Build Complete!');
		done();
	}
]));


