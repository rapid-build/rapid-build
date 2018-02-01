#! /usr/bin/env node

/* Requires
 ***********/
var path = require('path');

/* Process Env
 **************/
const BUILD_PATH   = path.join(__dirname, '..');
const RB_PKG       = require(path.join(BUILD_PATH, 'package.json'));
process.env.RB_LIB = RB_PKG.build.lib === 'src' ? 'src': 'lib';

/* Constants
 ************/
const APP_PATH = process.cwd();
const FOR_LIB  = process.env.RB_LIB !== 'src'; // 'src' for development
const LIB_PATH = FOR_LIB ? path.join(BUILD_PATH, 'lib') : path.join(BUILD_PATH, 'src');
if (!FOR_LIB) require('coffeescript/register');

/* Config
 *********/
var config = {};
config.app   = {};
config.build = {};
config.app.path   = APP_PATH;
config.build.path = BUILD_PATH;
config.build.pkg  = RB_PKG;
config.app.build  = {};
config.app.build.opts = path.join(config.app.path, config.build.pkg.name);
config.build.helpers = {};
config.build.helpers.path = path.join(LIB_PATH, 'helpers');
config.build.cli = {};
config.build.cli.path = path.join(LIB_PATH, 'cli');
config.build.cli.opts = require(path.join(config.build.cli.path, 'get-cli-opts'))(config);
config.build.cli.templates = {}
config.build.cli.templates.path   = path.join(config.build.cli.path, 'templates');
config.build.cli.templates.client = path.join(config.build.cli.templates.path, 'client');
config.build.cli.templates.root   = path.join(config.build.cli.templates.path, 'root');
config.build.cli.templates.server = path.join(config.build.cli.templates.path, 'server');
config.build.generated = {};
config.build.generated.path = path.join(BUILD_PATH, 'generated');

/* Bootstrap
 ************/
require(path.join(config.build.cli.path, 'add-colors'))();
if (!!config.build.cli.opts.cacheClean)      return require(path.join(config.build.cli.path, 'cache-clean'))(config);
if (!!config.build.cli.opts.cacheList)       return require(path.join(config.build.cli.path, 'cache-list'))(config);
if (!!config.build.cli.opts.location)        return require(path.join(config.build.cli.path, 'location'))(config);
if (config.build.cli.opts.quickStart.length) return require(path.join(config.build.cli.path, 'quick-start'))(config);

var build = require(path.join(config.build.cli.path, 'get-build'))(config);
/**
 * Run Build - in the console type one of the following:
 * build
 * build test | test:client | test:server
 * build dev  | dev:test    | dev:test:client  | dev:test:server
 * build prod | prod:test   | prod:test:client | prod:test:server | prod:server
 *******************************************************************************/
build.execute(build.buildType).then(() => {
	console.log('Build Complete!'.attn);
});