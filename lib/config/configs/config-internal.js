var hasProp = {}.hasOwnProperty;

module.exports = function(config) {
  var internal, log, path, pathHelp, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  test = require(config.req.helpers + "/test")();
  internal = {
    rb: {
      client: {
        css: {
          imports: {}
        }
      }
    },
    app: {
      client: {
        css: {
          imports: {}
        }
      }
    }
  };
  internal.deleteFileImports = function(appOrRb, _path) {
    var imports, key;
    key = pathHelp.format(_path);
    imports = this[appOrRb].client.css.imports;
    if (!imports[key]) {
      return;
    }
    return delete imports[key];
  };
  internal.getImports = function(negated) {
    var appImports, imports, rbImports;
    if (negated == null) {
      negated = false;
    }
    rbImports = this.getImportsAppOrRb('rb', negated);
    appImports = this.getImportsAppOrRb('app', negated);
    return imports = [].concat(rbImports, appImports);
  };
  internal.getImportsAppOrRb = function(appOrRb, negated) {
    var _imports, i, imports, k1, len, v1, v2;
    if (negated == null) {
      negated = false;
    }
    imports = this[appOrRb].client.css.imports;
    if (!Object.keys(imports).length) {
      return [];
    }
    _imports = [];
    negated = negated ? '!' : '';
    for (k1 in imports) {
      if (!hasProp.call(imports, k1)) continue;
      v1 = imports[k1];
      if (!v1.length) {
        continue;
      }
      for (i = 0, len = v1.length; i < len; i++) {
        v2 = v1[i];
        _imports.push("" + negated + v2);
      }
    }
    return _imports;
  };
  config.internal = internal;
  test.log('true', config.internal, 'add internal to config');
  return config;
};
