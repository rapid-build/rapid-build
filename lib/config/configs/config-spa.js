module.exports = function(config, options) {
  var customSrcPath, distFile, distFilePath, getSrcFilePath, isCustom, log, path, pathHelp, pkg, spa, srcDir, srcFile, srcFilePath, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  pkg = require(config.req.app + "/package.json");
  pathHelp = require(config.req.helpers + "/path");
  test = require(config.req.helpers + "/test")();
  getSrcFilePath = function(_isCustom, _path) {
    var appDir, rbDir;
    rbDir = config.src.rb.client.dir;
    appDir = config.src.app.client.dir;
    if (!_isCustom) {
      return path.join(rbDir, 'spa.html');
    }
    _path = pathHelp.format(_path);
    if (_path[0] !== '/') {
      _path = "/" + _path;
    }
    _path = path.join(appDir, _path);
    return _path;
  };
  customSrcPath = options.spa.src.filePath;
  isCustom = !!customSrcPath;
  srcFilePath = getSrcFilePath(isCustom, customSrcPath);
  srcFile = path.basename(srcFilePath);
  srcDir = path.dirname(srcFilePath);
  distFile = options.spa.dist.fileName || srcFile;
  distFilePath = path.join(config.dist.app.client.dir, distFile);
  spa = {};
  spa.custom = isCustom;
  spa.title = options.spa.title || config.app.name || 'Application';
  spa.description = options.spa.description || pkg.description || null;
  spa.dist = {
    file: distFile,
    path: distFilePath
  };
  spa.src = {
    file: srcFile,
    dir: srcDir,
    path: srcFilePath
  };
  spa.placeholders = options.spa.placeholders || [];
  config.spa = spa;
  test.log('true', config.spa, 'add spa to config');
  return config;
};
