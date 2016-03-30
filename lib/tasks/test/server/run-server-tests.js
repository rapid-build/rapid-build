module.exports = function(config, gulp, taskOpts) {
  var api, cleanResultsFile, del, failureCheck, forWatchFile, fse, jasmine, path, promiseHelp, q, resultsFile, runMulti, runMultiDev, runTests, writeResultsFile;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  del = require('del');
  path = require('path');
  fse = require('fs-extra');
  promiseHelp = require(config.req.helpers + "/promise");
  jasmine = require(config.req.helpers + "/jasmine")(config);
  resultsFile = path.join(config.dist.app.server.dir, 'test-results.json');
  forWatchFile = !!taskOpts.watchFilePath;
  cleanResultsFile = function(src) {
    var defer;
    defer = q.defer();
    del(src, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  runTests = function(files) {
    return jasmine.init(files).execute();
  };
  writeResultsFile = function(src) {
    var results;
    results = jasmine.getResults();
    if (results.status !== 'failed') {
      return promiseHelp.get();
    }
    fse.writeJSONSync(src, results, {
      spaces: '\t'
    });
    return promiseHelp.get();
  };
  failureCheck = function() {
    var results;
    results = jasmine.getResults();
    if (results.status === 'passed') {
      return promiseHelp.get();
    }
    return process.on('exit', function() {
      var msg;
      msg = "Server test failed - created " + resultsFile;
      return console.error(msg.error);
    }).exit(1);
  };
  runMulti = function() {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return cleanResultsFile(resultsFile);
      }, function() {
        return runTests(config.glob.dist.app.server.test.js);
      }, function() {
        return writeResultsFile(resultsFile);
      }, function() {
        return failureCheck();
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  runMultiDev = function() {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return cleanResultsFile(resultsFile);
      }, function() {
        return runTests(config.glob.dist.app.server.test.js);
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runSingle: function(file) {
      return jasmine.init(file).reExecute();
    },
    runTask: function(env) {
      if (!config.build.server) {
        return promiseHelp.get();
      }
      if (env === 'dev') {
        return runMultiDev();
      }
      return runMulti();
    }
  };
  if (forWatchFile) {
    return api.runSingle(taskOpts.watchFilePath);
  }
  return api.runTask(taskOpts.env);
};
