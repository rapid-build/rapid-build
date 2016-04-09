/* Requires
 ***********/
// process.env.RB_LIB = 'src'
require('coffee-script/register');
var path = require('path'),
	gulp = require('gulp');

/* Vars
 *******/
var getBuildMode, getIsCiBuild;
var build, buildMode, isCiBuild, options;
var buildPath;
var pkg, gulpTask, buildTask;

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
buildPath = path.resolve(__dirname, '..');
buildMode = getBuildMode(process.argv[2]);
isCiBuild = getIsCiBuild(process.argv[2], process.argv[3]);
options   = require('./build-options')(buildMode, isCiBuild);
build     = require(buildPath)(gulp, options);

/* Init Tasks
 *************/
pkg       = require(`${buildPath}/package.json`);
gulpTask  = buildMode;
buildTask = pkg.name;
if (gulpTask && gulpTask != 'default') buildTask += `:${buildMode}`;
// console.log('TASKS:'.attn, gulpTask, buildTask);
if (!!gulp.tasks[gulpTask]) return

/**
 * Run Build - in the console type one of the following:
 * gulp
 * gulp test | test:client | test:server
 * gulp dev  | dev:test    | dev:test:client  | dev:test:server
 * gulp prod | prod:test   | prod:test:client | prod:test:server | prod:server
 ******************************************************************************/
gulp.task('default', [pkg.name], function(cb) {
	console.log('Build Complete!');
	cb();
})

if (gulpTask == 'default') return

gulp.task(gulpTask, [buildTask], function(cb) {
	console.log('Build Complete!');
	cb();
})


