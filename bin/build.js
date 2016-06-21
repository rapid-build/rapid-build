#! /usr/bin/env node
// process.env.RB_LIB = 'src'

/* Requires
 ***********/
var path  = require('path'),
	CSON  = require('cson'),
	merge = require('deepmerge');

/* Constants
 ************/
const APP_PATH   = process.cwd();
const BUILD_PATH = path.join(__dirname, '..');
const BUILD_PKG  = require(path.join(BUILD_PATH, 'package.json'));
const APP_OPTS   = path.join(APP_PATH, BUILD_PKG.name);

/* Helpers
 **********/
var help = {
	isEmptyObj: obj => {
		return Object.keys(obj).length === 0 && obj.constructor === Object;
	},
	getBuildType: type => {
		if (typeof type !== 'string') return 'default';
		type = type.trim().toLowerCase();
		if (/^(test|dev|prod)/i.test(type) === false) return 'default';
		return type;
	},
	getBuildTypeOpts: (type, extraOpts) => {
		var types = ['common'],
			bType = type.split(':')[0], // base type
			isDev = /^(default|test|dev)/i.test(bType),
			start = bType == 'default' && extraOpts[2] != 'default' ? 2 : 3;

		extraOpts = extraOpts.slice(start);
		if (isDev) types.push('dev');
		if (bType == 'test') types.push(bType);
		if (type.indexOf(':test') != -1) types.push('test');
		if (bType == 'prod') types.push(bType);
		types = types.concat(extraOpts);
		return types;
	},
	getBuildOpts: () => {
		try { return CSON.requireFile(`${APP_OPTS}.cson`); }
		catch(e) {
			try { return require(`${APP_OPTS}.json`); }
			catch(e) {
				try { return require(`${APP_OPTS}.js`); }
				catch(e) { return {}; }
			}
		}
	},
	mergeBuildOpts: (opts, typeOpts) => {
		if (help.isEmptyObj(opts)) return {};
		var mergedOpts = {},
			optKeys    = Object.keys(opts);
		for (var type of typeOpts) {
			if (optKeys.indexOf(type) == -1) continue;
			mergedOpts = merge(mergedOpts, opts[type]);
		}
		return mergedOpts;
	}
}

/* Setup
 ********/
var build = {};
build.buildType     = help.getBuildType(process.argv[2]);
build.buildTypeOpts = help.getBuildTypeOpts(build.buildType, process.argv);
build.buildOpts     = help.getBuildOpts();
build.buildOpts     = help.mergeBuildOpts(build.buildOpts, build.buildTypeOpts);
build.execute       = require(BUILD_PATH)(build.buildOpts);

/**
 * Run Build - in the console type one of the following:
 * node build
 * node build test | test:client | test:server
 * node build dev  | dev:test    | dev:test:client  | dev:test:server
 * node build prod | prod:test   | prod:test:client | prod:test:server | prod:server
 *******************************************************************************/
build.execute(build.buildType).then(() => {
	console.log('Build Complete!')
})