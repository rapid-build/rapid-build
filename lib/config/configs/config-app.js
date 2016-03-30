module.exports = function(config, options) {
  var app, log, path, pkg, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  pkg = require(config.req.app + "/package.json");
  app = {};
  app.name = pkg.name;
  app.version = pkg.version;
  app.dir = config.req.app;
  if (!app.name) {
    app.name = path.basename(app.dir);
  }
  config.app = app;
  test.log('true', config.app, 'add app to config');
  return config;
};
