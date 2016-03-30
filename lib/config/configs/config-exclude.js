var hasProp = {}.hasOwnProperty;

module.exports = function(config, options) {
  var exclude, formatFilesFrom, get, getExcludeFromDirTypes, getExcludeFromDist, getExcludeFromDistType, isType, log, path, pathHelp, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  isType = require(config.req.helpers + "/isType");
  pathHelp = require(config.req.helpers + "/path");
  test = require(config.req.helpers + "/test")();
  get = {
    opt: {
      deep2: function(type, opt, defaultVal) {
        opt = options.exclude[type][opt];
        if (isType["null"](opt)) {
          return defaultVal;
        }
        return opt;
      },
      deep3: function(base, opt, type, defaultVal) {
        opt = options.exclude[base][opt][type];
        if (isType["null"](opt)) {
          return defaultVal;
        }
        return opt;
      }
    }
  };
  exclude = {
    spa: !!options.exclude.spa,
    angular: {
      files: get.opt.deep2('angular', 'files', false)
    },
    "default": {
      client: {
        files: get.opt.deep3('default', 'client', 'files', false)
      },
      server: {
        files: get.opt.deep3('default', 'server', 'files', false)
      }
    },
    rb: {
      from: {
        cacheBust: [],
        minFile: {
          scripts: [],
          styles: []
        },
        spaFile: {
          scripts: [],
          styles: []
        },
        dist: {
          client: [],
          server: []
        }
      }
    },
    app: {
      from: {
        cacheBust: get.opt.deep2('from', 'cacheBust', []),
        minFile: {
          scripts: get.opt.deep3('from', 'minFile', 'scripts', []),
          styles: get.opt.deep3('from', 'minFile', 'styles', [])
        },
        spaFile: {
          scripts: get.opt.deep3('from', 'spaFile', 'scripts', []),
          styles: get.opt.deep3('from', 'spaFile', 'styles', [])
        },
        dist: {
          client: get.opt.deep3('from', 'dist', 'client', []),
          server: get.opt.deep3('from', 'dist', 'server', [])
        }
      }
    }
  };
  formatFilesFrom = function(opt, type) {
    var _path, appOrRb, forType, i, len, negate, paths, ref, results;
    ref = ['app', 'rb'];
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      appOrRb = ref[i];
      paths = exclude[appOrRb].from[opt][type];
      forType = !!paths;
      if (!forType) {
        paths = exclude[appOrRb].from[opt];
      }
      if (!paths.length) {
        continue;
      }
      paths = (function() {
        var j, len1, results1;
        results1 = [];
        for (j = 0, len1 = paths.length; j < len1; j++) {
          _path = paths[j];
          results1.push(pathHelp.makeRelative(_path));
        }
        return results1;
      })();
      paths = (function() {
        var j, len1, results1;
        results1 = [];
        for (j = 0, len1 = paths.length; j < len1; j++) {
          _path = paths[j];
          results1.push(path.join(config.dist[appOrRb].client.dir, _path));
        }
        return results1;
      })();
      negate = opt === 'minFile' ? '' : '!';
      paths = (function() {
        var j, len1, results1;
        results1 = [];
        for (j = 0, len1 = paths.length; j < len1; j++) {
          _path = paths[j];
          results1.push("" + negate + _path);
        }
        return results1;
      })();
      if (forType) {
        results.push(exclude[appOrRb].from[opt][type] = paths);
      } else {
        results.push(exclude[appOrRb].from[opt] = paths);
      }
    }
    return results;
  };
  formatFilesFrom('cacheBust');
  formatFilesFrom('minFile', 'scripts');
  formatFilesFrom('minFile', 'styles');
  formatFilesFrom('spaFile', 'scripts');
  formatFilesFrom('spaFile', 'styles');
  getExcludeFromDirTypes = function(appOrRb, loc) {
    var k1, ref, types, v1;
    types = {};
    types[appOrRb] = {};
    types[appOrRb][loc] = {};
    ref = config.src[appOrRb][loc];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      if (k1 === 'dir') {
        continue;
      }
      types[appOrRb][loc][k1] = {};
      types[appOrRb][loc][k1].dir = v1.dir;
    }
    return types;
  };
  getExcludeFromDistType = function(types, appOrRb, loc, _path) {
    var allTypes, ext, index, k1, lang, ref, type, v1;
    type = null;
    allTypes = ['bower', 'images', 'libs'];
    ref = types[appOrRb][loc];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      index = _path.indexOf(v1.dir);
      if (index === 0) {
        ext = path.extname(_path);
        lang = ext && ext.indexOf('*') === -1 ? ext.substr(1) : 'all';
        if (lang === 'scss') {
          lang = 'sass';
        }
        if (allTypes.indexOf(k1) !== -1) {
          lang = 'all';
        }
        type = {
          type: k1,
          lang: lang,
          path: "!" + _path
        };
        break;
      }
    }
    return type;
  };
  getExcludeFromDist = function(appOrRb, loc) {
    var _path, eTypes, i, len, paths, srcPath, type, types;
    paths = exclude[appOrRb].from.dist[loc];
    if (!paths.length) {
      return [];
    }
    types = getExcludeFromDirTypes(appOrRb, loc);
    srcPath = config.src[appOrRb][loc].dir;
    paths = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = paths.length; i < len; i++) {
        _path = paths[i];
        results.push(path.join(srcPath, _path));
      }
      return results;
    })();
    eTypes = {};
    for (i = 0, len = paths.length; i < len; i++) {
      _path = paths[i];
      type = getExcludeFromDistType(types, appOrRb, loc, _path);
      if (!type) {
        continue;
      }
      if (!eTypes[type.type]) {
        eTypes[type.type] = {};
      }
      if (!eTypes[type.type][type.lang]) {
        eTypes[type.type][type.lang] = [];
      }
      eTypes[type.type][type.lang].push(type.path);
    }
    if (!Object.keys(eTypes).length) {
      return [];
    }
    return eTypes;
  };
  exclude.rb.from.dist.client = getExcludeFromDist('rb', 'client');
  exclude.rb.from.dist.server = getExcludeFromDist('rb', 'server');
  exclude.app.from.dist.client = getExcludeFromDist('app', 'client');
  exclude.app.from.dist.server = getExcludeFromDist('app', 'server');
  config.exclude = exclude;
  test.log('true', config.exclude, 'add exclude to config');
  return config;
};
