module.exports = function(config, rbDir) {
  var fs, getIsSymlink, log, path, pkg, rb, rootPath, test;
  fs = require('fs');
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  rootPath = path.resolve(config.req.rb, '..');
  pkg = require(rootPath + "/package.json");
  rb = {};
  rb.name = pkg.name;
  rb.version = pkg.version;
  rb.root = rootPath;
  rb.dir = rbDir;
  getIsSymlink = function() {
    var dir, e, error, isSymlink;
    dir = path.join(config.req.app, 'node_modules', rb.name);
    try {
      return isSymlink = fs.lstatSync(dir).isSymbolicLink();
    } catch (error) {
      e = error;
      return isSymlink = false;
    }
  };
  rb.isSymlink = getIsSymlink();
  rb.tasks = {};
  rb.tasks["default"] = rb.name;
  rb.tasks.test = rb.tasks["default"] + ":test";
  rb.tasks['test:client'] = rb.tasks["default"] + ":test:client";
  rb.tasks['test:server'] = rb.tasks["default"] + ":test:server";
  rb.tasks.dev = rb.tasks["default"] + ":dev";
  rb.tasks['dev:test'] = rb.tasks["default"] + ":dev:test";
  rb.tasks['dev:test:client'] = rb.tasks["default"] + ":dev:test:client";
  rb.tasks['dev:test:server'] = rb.tasks["default"] + ":dev:test:server";
  rb.tasks.prod = rb.tasks["default"] + ":prod";
  rb.tasks['prod:server'] = rb.tasks["default"] + ":prod:server";
  rb.tasks['prod:test'] = rb.tasks["default"] + ":prod:test";
  rb.tasks['prod:test:client'] = rb.tasks["default"] + ":prod:test:client";
  rb.tasks['prod:test:server'] = rb.tasks["default"] + ":prod:test:server";
  rb.prefix = {};
  rb.prefix.task = pkg.tasksPrefix;
  rb.prefix.distDir = rb.name;
  config.rb = rb;
  test.log('true', config.rb, 'add rb to config');
  return config;
};
