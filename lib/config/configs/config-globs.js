var hasProp = {}.hasOwnProperty;

module.exports = function(config) {
  var addCacheBust, addCacheBustExcludes, addDistDir, addExcludeFromDist, addFirst, addGlob, addLast, addNodeModules, addNodeModulesDistAndSrc, excludeRbServerFiles, excludeServerTests, excludeSpaSrc, exts, getExts, glob, initGlob, isType, lang, log, order, path, pathHelp, removeAppAngularMocksDir, removeRbAngularMocks, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  isType = require(config.req.helpers + "/isType");
  pathHelp = require(config.req.helpers + "/path");
  test = require(config.req.helpers + "/test")();
  exts = {
    coffee: 'coffee',
    css: 'css',
    es6: 'es6',
    fonts: 'eot,svg,ttf,woff,woff2',
    html: 'html',
    images: 'gif,jpg,jpeg,png',
    js: 'js',
    less: 'less',
    sass: 'sass,scss'
  };
  getExts = function(_exts) {
    var combined, ext, i, j, len, total;
    _exts = _exts.split(',');
    _exts = (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = _exts.length; j < len; j++) {
        ext = _exts[j];
        results.push(ext.trim());
      }
      return results;
    })();
    combined = '';
    total = _exts.length - 1;
    for (i = j = 0, len = _exts.length; j < len; i = ++j) {
      ext = _exts[i];
      combined += exts[ext];
      if (i !== total) {
        combined += ',';
      }
    }
    return combined;
  };
  lang = {
    all: '/**',
    coffee: "/**/*." + exts.coffee,
    css: "/**/*." + exts.css,
    es6: "/**/*." + exts.es6,
    html: "/**/*." + exts.html,
    images: "/**/*.{" + exts.images + "}",
    js: "/**/*." + exts.js,
    less: "/**/*." + exts.less,
    sass: "/**/*.{" + exts.sass + "}",
    bustFiles: "/**/*.{" + (getExts('css,js,images')) + "}",
    bustRefs: "/**/*.{" + (getExts('html,css,js')) + "}"
  };
  initGlob = function() {
    return ['dist', 'src'].forEach(function(loc) {
      glob[loc] = {};
      return ['rb', 'app'].forEach(function(v1) {
        glob[loc][v1] = {};
        return ['client', 'server'].forEach(function(v2) {
          var _path;
          glob[loc][v1][v2] = {};
          if (v2 !== 'server') {
            _path = path.join(config[loc][v1][v2].dir, lang.all);
            _path = pathHelp.format(_path);
            return glob[loc][v1][v2].all = _path;
          }
        });
      });
    });
  };
  addGlob = function(loc, type, langs, includeBower, includeLibs) {
    var _path, bowerPath, k1, k2, libsPath, ref, results, v1, v2, v3;
    ref = glob[loc];
    results = [];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          if (k2 === 'server' && ['scripts', 'test'].indexOf(type) === -1) {
            continue;
          }
          if (k2 === 'server' && (includeBower || includeLibs)) {
            continue;
          }
          if (!isType.object(v2[type])) {
            v2[type] = {};
          }
          results1.push((function() {
            var j, len, results2;
            results2 = [];
            for (j = 0, len = langs.length; j < len; j++) {
              v3 = langs[j];
              if (k2 === 'server' && type === 'test' && v3 === 'css') {
                continue;
              }
              _path = config[loc][k1][k2][type].dir;
              _path = pathHelp.format(path.join(_path, lang[v3]));
              if (includeBower || includeLibs) {
                bowerPath = config[loc][k1][k2]['bower'].dir;
                libsPath = config[loc][k1][k2]['libs'].dir;
                bowerPath = pathHelp.format(path.join(bowerPath, lang[v3]));
                libsPath = pathHelp.format(path.join(libsPath, lang[v3]));
                results2.push(v2[type][v3] = [bowerPath, libsPath, _path]);
              } else {
                results2.push(v2[type][v3] = [_path]);
              }
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };
  glob = {};
  initGlob();
  addGlob('src', 'images', ['all']);
  addGlob('src', 'libs', ['all']);
  addGlob('src', 'scripts', ['js']);
  addGlob('src', 'scripts', ['coffee']);
  addGlob('src', 'scripts', ['es6']);
  addGlob('src', 'styles', ['css']);
  addGlob('src', 'styles', ['less']);
  addGlob('src', 'styles', ['sass']);
  addGlob('src', 'test', ['css', 'js']);
  addGlob('src', 'test', ['coffee']);
  addGlob('src', 'test', ['es6']);
  addGlob('src', 'views', ['html']);
  addGlob('dist', 'bower', ['all', 'css', 'js']);
  addGlob('dist', 'images', ['all']);
  addGlob('dist', 'libs', ['all', 'css', 'js']);
  addGlob('dist', 'scripts', ['all']);
  addGlob('dist', 'scripts', ['js'], true, true);
  addGlob('dist', 'styles', ['all']);
  addGlob('dist', 'styles', ['css'], true, true);
  addGlob('dist', 'test', ['css', 'js']);
  addGlob('dist', 'views', ['all']);
  addGlob('dist', 'views', ['html']);
  excludeSpaSrc = function(type, lang) {
    var spa;
    spa = pathHelp.format(config.spa.src.path);
    return glob.src.app.client[type][lang].push("!" + spa);
  };
  excludeSpaSrc('libs', 'all');
  excludeSpaSrc('views', 'html');
  excludeServerTests = function() {
    var appOrRb, exclude, j, k1, len, ref, results, v1;
    ref = ['app', 'rb'];
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      appOrRb = ref[j];
      exclude = path.join(config.src[appOrRb].server.test.dir, lang.all);
      exclude = pathHelp.format(exclude);
      exclude = "!" + exclude;
      results.push((function() {
        var ref1, results1;
        ref1 = glob.src[appOrRb].server.scripts;
        results1 = [];
        for (k1 in ref1) {
          if (!hasProp.call(ref1, k1)) continue;
          v1 = ref1[k1];
          results1.push(v1.push(exclude));
        }
        return results1;
      })());
    }
    return results;
  };
  excludeServerTests();
  addCacheBust = function(type, lang) {
    var _glob;
    _glob = path.join(config.dist.app.client.dir, lang);
    _glob = pathHelp.format(_glob);
    return glob.dist.app.client.cacheBust[type] = [_glob];
  };
  addCacheBustExcludes = function() {
    return glob.dist.app.client.cacheBust.files = [].concat(glob.dist.app.client.cacheBust.files, pathHelp.formats(config.exclude.rb.from.cacheBust), pathHelp.formats(config.exclude.app.from.cacheBust));
  };
  glob.dist.app.client.cacheBust = {};
  addCacheBust('files', lang.bustFiles);
  addCacheBust('references', lang.bustRefs);
  addCacheBustExcludes();
  removeAppAngularMocksDir = function() {
    var k, noMocksGlob, results, srcScripts, v;
    srcScripts = glob.src.app.client.scripts;
    noMocksGlob = path.join(config.angular.httpBackend.dir, lang.all);
    noMocksGlob = pathHelp.format(noMocksGlob);
    noMocksGlob = "!" + noMocksGlob;
    results = [];
    for (k in srcScripts) {
      if (!hasProp.call(srcScripts, k)) continue;
      v = srcScripts[k];
      results.push(srcScripts[k].push(noMocksGlob));
    }
    return results;
  };
  removeRbAngularMocks = function() {
    glob.dist.rb.client.scripts.js.splice(1, 1);
    return removeAppAngularMocksDir();
  };
  glob.removeRbAngularMocks = function() {
    if (config.env.is.prod) {
      if (!config.angular.httpBackend.prod) {
        return removeRbAngularMocks();
      }
    } else if (!config.angular.httpBackend.dev) {
      return removeRbAngularMocks();
    }
  };
  addDistDir = function(appOrRb, type, ext) {
    var k1, results, v1;
    results = [];
    for (k1 in type) {
      if (!hasProp.call(type, k1)) continue;
      v1 = type[k1];
      results.push(v1.forEach(function(v, i) {
        v1[i] = path.join(config.dist[appOrRb].client.dir, v);
        v1[i] += "." + ext;
        return v1[i] = pathHelp.format(v1[i]);
      }));
    }
    return results;
  };
  addFirst = function(appOrRb, type, array, ext) {
    if (!array.length) {
      return;
    }
    return array.slice().reverse().forEach(function(v) {
      return glob.dist[appOrRb].client[type][ext].unshift(v);
    });
  };
  addLast = function(appOrRb, type, array, ext) {
    if (!array.length) {
      return;
    }
    return array.forEach(function(v) {
      return glob.dist[appOrRb].client[type][ext].push("!" + v, v);
    });
  };
  order = function() {
    var ext, k1, k2, ref, results, tot, v1, v2;
    ref = config.order;
    results = [];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          tot = config.order[k1][k2].first.length + config.order[k1][k2].last.length;
          if (!tot) {
            continue;
          }
          if (k2 === 'scripts') {
            ext = 'js';
          }
          if (k2 === 'styles') {
            ext = 'css';
          }
          addDistDir(k1, v2, ext);
          addFirst(k1, k2, v2.first, ext);
          results1.push(addLast(k1, k2, v2.last, ext));
        }
        return results1;
      })());
    }
    return results;
  };
  order();
  addExcludeFromDist = function(loc) {
    var appOrRb, ePaths, excludes, j, k1, k2, len, ref, results, v1, v2;
    ref = ['app', 'rb'];
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      appOrRb = ref[j];
      excludes = config.exclude[appOrRb].from.dist[loc];
      if (!Object.keys(excludes).length) {
        continue;
      }
      results.push((function() {
        var ref1, results1;
        ref1 = glob.src[appOrRb][loc];
        results1 = [];
        for (k1 in ref1) {
          if (!hasProp.call(ref1, k1)) continue;
          v1 = ref1[k1];
          if (k1 === 'all') {
            continue;
          }
          results1.push((function() {
            var results2;
            results2 = [];
            for (k2 in v1) {
              if (!hasProp.call(v1, k2)) continue;
              v2 = v1[k2];
              if (!v2.length) {
                continue;
              }
              if (!excludes[k1]) {
                continue;
              }
              ePaths = excludes[k1]['all'];
              ePaths = ePaths ? ePaths : excludes[k1][k2];
              if (!ePaths) {
                continue;
              }
              if (!ePaths.length) {
                continue;
              }
              results2.push(glob.src[appOrRb][loc][k1][k2] = v2.concat(ePaths));
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };
  addExcludeFromDist('client');
  addExcludeFromDist('server');
  addNodeModulesDistAndSrc = function() {
    var appOrRb, loc, ref, results, v;
    ref = config.node_modules;
    results = [];
    for (appOrRb in ref) {
      v = ref[appOrRb];
      glob.node_modules[appOrRb] = {};
      results.push((function() {
        var j, len, ref1, results1;
        ref1 = ['dist', 'src'];
        results1 = [];
        for (j = 0, len = ref1.length; j < len; j++) {
          loc = ref1[j];
          results1.push(glob.node_modules[appOrRb][loc] = {});
        }
        return results1;
      })());
    }
    return results;
  };
  addNodeModules = function(loc) {
    var _path, appOrRb, module, ref, results, v;
    ref = config.node_modules;
    results = [];
    for (appOrRb in ref) {
      v = ref[appOrRb];
      results.push((function() {
        var j, len, ref1, results1;
        ref1 = v.modules;
        results1 = [];
        for (j = 0, len = ref1.length; j < len; j++) {
          module = ref1[j];
          _path = path.join(v[loc].modules[module], lang.all);
          _path = pathHelp.format(_path);
          results1.push(glob.node_modules[appOrRb][loc][module] = _path);
        }
        return results1;
      })());
    }
    return results;
  };
  glob.node_modules = {};
  addNodeModulesDistAndSrc();
  addNodeModules('src');
  glob.browserSync = pathHelp.format(path.join(pathHelp.format(config.dist.app.client.dir), lang.all));
  excludeRbServerFiles = function() {
    var k1, results, scripts, v1;
    if (!config.exclude["default"].server.files) {
      return;
    }
    scripts = glob.src.rb.server.scripts;
    results = [];
    for (k1 in scripts) {
      if (!hasProp.call(scripts, k1)) continue;
      v1 = scripts[k1];
      results.push(scripts[k1] = []);
    }
    return results;
  };
  excludeRbServerFiles();
  config.glob = glob;
  test.log('true', config.glob, 'add glob to config');
  return config;
};
