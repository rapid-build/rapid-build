module.exports = function(config) {
  var getInfo, log, path, templates, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  getInfo = function(srcFile, destFile, destDir) {
    return {
      src: {
        path: path.join(templates.dir, srcFile)
      },
      dest: {
        file: destFile,
        dir: destDir,
        path: path.join(destDir, destFile)
      }
    };
  };
  templates = {};
  templates.dir = path.join(config.rb.dir, 'templates');
  templates.angularModules = getInfo('angular-modules.tpl', 'app.coffee', config.src.rb.client.scripts.dir);
  config.templates = templates;
  test.log('true', config.templates, 'add templates to config');
  return config;
};
