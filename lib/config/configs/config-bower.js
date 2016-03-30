module.exports = function(config, options) {
  var addInfo, bower, defaults, log, path, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  defaults = {
    file: 'bower.json'
  };
  bower = {};
  bower.rb = {};
  bower.app = {};
  addInfo = function() {
    return ['app', 'rb'].forEach(function(v) {
      bower[v].file = defaults.file;
      bower[v].dir = v === 'rb' ? config.generated.pkg.path : config[v].dir;
      return bower[v].path = path.join(bower[v].dir, bower[v].file);
    });
  };
  addInfo();
  config.bower = bower;
  test.log('true', config.bower, 'add bower to config');
  return config;
};
