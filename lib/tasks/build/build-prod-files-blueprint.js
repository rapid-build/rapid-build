module.exports = function(config, gulp) {
  var DevFiles, MinFileExcludes, MinFiles, api, buildTask, fse, log, path, pathHelp, promiseHelp, q, setDevFiles, setMinFileExcludes, setMinFiles, setMinFilesCleanup, setMultiMinFileExcludes, setMultiMinFiles, setMultiMinFilesCleanup;
  q = require('q');
  path = require('path');
  fse = require('fs-extra');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  promiseHelp = require(config.req.helpers + "/promise");
  DevFiles = {};
  MinFileExcludes = {
    scripts: [],
    styles: []
  };
  MinFiles = {
    scripts: [],
    styles: []
  };
  buildTask = function() {
    var defer, format, jsonFile;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    jsonFile = config.generated.pkg.files.prodFilesBlueprint;
    fse.writeJson(jsonFile, MinFiles, format, function(e) {
      console.log('built prod-files-blueprint.json'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  setMinFileExcludes = function(type) {
    var appDir, defer, src;
    defer = q.defer();
    appDir = pathHelp.format(config.app.dir);
    src = [].concat(config.exclude.rb.from.minFile[type], config.exclude.app.from.minFile[type]);
    gulp.src(src, {
      buffer: false
    }).on('data', function(file) {
      var _path;
      _path = pathHelp.format(file.path).replace(appDir + "/", '');
      return MinFileExcludes[type].push(_path);
    }).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  setMinFiles = function(type) {
    var cnt, exclude, ext, file, fileName, j, len, minCnt, ref;
    cnt = 0;
    minCnt = 0;
    exclude = false;
    ext = type === 'scripts' ? 'js' : 'css';
    ref = DevFiles[type];
    for (j = 0, len = ref.length; j < len; j++) {
      file = ref[j];
      if (MinFileExcludes[type].indexOf(file) !== -1) {
        cnt++;
        exclude = true;
        MinFiles[type].push({
          cnt: cnt,
          type: 'exclude',
          name: null,
          files: file
        });
      } else {
        if (exclude || !cnt) {
          cnt++;
          minCnt++;
          exclude = false;
          fileName = path.basename(config.fileName[type].min, "." + ext);
          MinFiles[type].push({
            cnt: cnt,
            type: 'include',
            name: fileName + "." + minCnt + "." + ext,
            files: []
          });
        }
        MinFiles[type][cnt - 1].files.push(file);
      }
    }
    return promiseHelp.get();
  };
  setMinFilesCleanup = function(type) {
    var ext, file, i, includes, j, len, ref;
    ext = type === 'scripts' ? 'js' : 'css';
    includes = {
      total: 0,
      index: void 0
    };
    ref = MinFiles[type];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      file = ref[i];
      if (file.type === 'include') {
        includes.total++;
        if (includes.total > 1) {
          break;
        }
        includes.index = i;
      }
    }
    if (includes.total !== 1) {
      return promiseHelp.get();
    }
    MinFiles[type][includes.index].name = config.fileName[type].min;
    return promiseHelp.get();
  };
  setDevFiles = function() {
    var files;
    files = require(config.generated.pkg.files.files);
    DevFiles = {
      scripts: files.client.scripts,
      styles: files.client.styles
    };
    return promiseHelp.get();
  };
  setMultiMinFileExcludes = function() {
    var defer;
    defer = q.defer();
    q.all([setMinFileExcludes('scripts'), setMinFileExcludes('styles')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  setMultiMinFiles = function() {
    var defer;
    defer = q.defer();
    q.all([setMinFiles('scripts'), setMinFiles('styles')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  setMultiMinFilesCleanup = function() {
    var defer;
    defer = q.defer();
    q.all([setMinFilesCleanup('scripts'), setMinFilesCleanup('styles')]).done(function() {
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
          return setDevFiles();
        }, function() {
          return setMultiMinFileExcludes();
        }, function() {
          return setMultiMinFiles();
        }, function() {
          return setMultiMinFilesCleanup();
        }, function() {
          return buildTask();
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
