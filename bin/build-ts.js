#! /usr/bin/env node
process.env.RB_LIB = 'dist';

/* Requires
 ***********/
var path = require('path');

/* Constants
 ************/
const BUILDS        = ['dist', 'src', 'lib'];
const APP_PATH      = process.cwd();
const BIN_PATH      = __dirname;
const BUILD_PATH    = path.join(BIN_PATH, '..');
const OLD_BIN_BUILD = path.join(BIN_PATH, 'build.js');

/* Set RB_LIB and LIB_PATH
 **************************/
var RB_LIB = process.env.RB_LIB;
	RB_LIB = typeof RB_LIB === 'string' ? RB_LIB.toLowerCase() : RB_LIB;
switch (RB_LIB) {
	case BUILDS[0]: RB_LIB = BUILDS[0]; break;
	case BUILDS[1]: RB_LIB = BUILDS[1]; break;
	default:        RB_LIB = BUILDS[2];
}
const LIB_PATH = path.join(BUILD_PATH, RB_LIB);

/* Helpers
 **********/
var logBuildMsg = msg => {
	var div = '-----------------';
	console.log(`${div}\nrunning ${msg} build\n${div}`.toUpperCase());
}

/* Run Old Build
 ****************/
if (RB_LIB === BUILDS[2]) {
	logBuildMsg('old');
	return require(OLD_BIN_BUILD);
}

/* Run New Build (return promise)
 *********************************/
logBuildMsg('new');
var build = require(LIB_PATH)();
return build;