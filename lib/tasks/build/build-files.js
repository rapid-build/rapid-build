module.exports = function(config, gulp) {
  var addData, api, buildData, buildFile, clearData, data, fse, getAllFiles, getExcludes, getFiles, getGlob, getImportExcludes, globs, gs, log, path, pathHelp, processFiles, q, setGlobs;
  q = require('q');
  path = require('path');
  fse = require('fs-extra');
  gs = require('glob-stream');
  pathHelp = require(config.req.helpers + "/path");
  log = require(config.req.helpers + "/log");
  data = {
    client: {
      styles: [],
      scripts: []
    }
  };
  globs = null;
  buildFile = function(json) {
    var defer, format, jsonFile;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    jsonFile = config.generated.pkg.files.files;
    fse.writeJson(jsonFile, json, format, function(e) {
      console.log('built files.json'.yellow);
      clearData();
      return defer.resolve();
    });
    return defer.promise;
  };
  clearData = function() {
    data.client.styles = [];
    return data.client.scripts = [];
  };
  getExcludes = function(appOrRb, type, glob) {
    var spaExcludes;
    spaExcludes = config.exclude[appOrRb].from.spaFile[type];
    if (!spaExcludes.length) {
      return glob;
    }
    glob = glob.concat(spaExcludes);
    return glob;
  };
  getImportExcludes = function(appOrRb, type, glob) {
    var imports;
    imports = config.internal.getImportsAppOrRb(appOrRb, true);
    if (!imports.length) {
      return glob;
    }
    glob = glob.concat(imports);
    return glob;
  };
  getGlob = function(appOrRb, type, lang) {
    var glob;
    glob = config.glob.dist[appOrRb].client[type][lang];
    glob = getExcludes(appOrRb, type, glob);
    if (lang === 'css') {
      glob = getImportExcludes(appOrRb, type, glob);
    }
    return glob;
  };
  setGlobs = function() {
    return globs = {
      css: {
        rb: getGlob('rb', 'styles', 'css'),
        app: getGlob('app', 'styles', 'css')
      },
      js: {
        rb: getGlob('rb', 'scripts', 'js'),
        app: getGlob('app', 'scripts', 'js')
      }
    };
  };
  processFiles = function(files) {
    var appDir;
    appDir = pathHelp.format(config.app.dir) + '/';
    files.forEach(function(v, i) {
      return files[i] = pathHelp.format(files[i]).replace(appDir, '');
    });
    return files;
  };
  addData = function(type, files) {
    files = processFiles(files);
    return files.forEach(function(v, i) {
      return data.client[type].push(v);
    });
  };
  getFiles = function(type, glob) {
    var defer, files, opts, stream;
    files = [];
    defer = q.defer();
    opts = {
      allowEmpty: true
    };
    stream = gs.create(glob, opts);
    stream.on('data', function(file) {
      var _path;
      _path = path.normalize(file.path);
      _path = pathHelp.format(_path);
      return files.push(pathHelp.format(_path));
    }).on('end', function() {
      addData(type, files);
      return defer.resolve();
    });
    return defer.promise;
  };
  getAllFiles = function(type, lang) {
    var appAndRb, defer, tasks;
    tasks = [];
    defer = q.defer();
    appAndRb = Object.keys(globs[lang]);
    appAndRb.forEach(function(appOrRb) {
      return tasks.push(function() {
        return getFiles(type, globs[lang][appOrRb]);
      });
    });
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  buildData = function() {
    var defer;
    defer = q.defer();
    setGlobs();
    q.all([getAllFiles('styles', 'css'), getAllFiles('scripts', 'js')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return buildData();
        }, function() {
          return buildFile(data);
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
