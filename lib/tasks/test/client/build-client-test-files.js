module.exports = function(config, gulp) {
  var Files, TestFiles, addFilesToTestFiles, addMultiFilesToTestFiles, api, buildTask, fse, log, moduleHelp, path, pathHelp, promiseHelp, q, setFiles, setMultiTestFiles, setTestFiles;
  q = require('q');
  path = require('path');
  fse = require('fs-extra');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  moduleHelp = require(config.req.helpers + "/module");
  promiseHelp = require(config.req.helpers + "/promise");
  Files = {};
  TestFiles = {
    client: {
      scriptsTestCount: 0,
      stylesTestCount: 0,
      scripts: [],
      styles: []
    }
  };
  buildTask = function() {
    var defer, format, jsonFile;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    jsonFile = config.generated.pkg.files.testFiles;
    fse.writeJson(jsonFile, TestFiles, format, function(e) {
      console.log("built test-files.json".yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  setTestFiles = function(appOrRb, type) {
    var appDir, defer, src;
    defer = q.defer();
    appDir = pathHelp.format(config.app.dir);
    src = config.test.dist[appOrRb].client[type];
    gulp.src(src, {
      buffer: false
    }).on('data', function(file) {
      var _path;
      _path = pathHelp.format(file.path).replace(appDir + "/", '');
      if (appOrRb === 'app') {
        TestFiles.client[type + "TestCount"]++;
      }
      return TestFiles.client[type].push(_path);
    }).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  addFilesToTestFiles = function(type) {
    TestFiles.client[type] = [].concat(Files[type], TestFiles.client[type]);
    return promiseHelp.get();
  };
  setFiles = function(jsonEnvFile) {
    var files;
    jsonEnvFile = path.join(config.generated.pkg.files.path, jsonEnvFile);
    moduleHelp.cache["delete"](jsonEnvFile);
    files = require(jsonEnvFile);
    Files = {
      scripts: files.client.scripts,
      styles: files.client.styles
    };
    return promiseHelp.get();
  };
  setMultiTestFiles = function() {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return setTestFiles('rb', 'scripts');
      }, function() {
        return setTestFiles('rb', 'styles');
      }, function() {
        return setTestFiles('app', 'scripts');
      }, function() {
        return setTestFiles('app', 'styles');
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  addMultiFilesToTestFiles = function() {
    var defer;
    defer = q.defer();
    q.all([addFilesToTestFiles('scripts'), addFilesToTestFiles('styles')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer, jsonEnvFile, tasks;
      defer = q.defer();
      jsonEnvFile = config.env.is.prod ? 'prod-files.json' : 'files.json';
      tasks = [
        function() {
          return setFiles(jsonEnvFile);
        }, function() {
          return setMultiTestFiles();
        }, function() {
          return addMultiFilesToTestFiles();
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
