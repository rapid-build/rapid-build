module.exports = function(config, gulp, taskOpts) {
  var Server, TestResults, api, cleanResultsFile, del, failureCheck, format, formatScripts, fs, getKarmaConfig, getTestsFile, hasTestsCheck, moduleHelp, path, promiseHelp, q, resultsFile, runDefaultTask, runDevTask, runDevTests, runTests, startKarmaServer, updateTestResults, writeResultsFile;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  fs = require('fs');
  del = require('del');
  path = require('path');
  Server = require('karma').Server;
  moduleHelp = require(config.req.helpers + "/module");
  promiseHelp = require(config.req.helpers + "/promise");
  format = require(config.req.helpers + "/format")();
  resultsFile = path.join(config.dist.app.client.dir, 'test-results.json');
  TestResults = {
    status: 'passed',
    total: 0,
    passed: 0,
    failed: 0
  };
  getTestsFile = function() {
    var tests;
    tests = config.generated.pkg.files.testFiles;
    moduleHelp.cache["delete"](tests);
    tests = require(tests).client;
    return tests;
  };
  getKarmaConfig = function() {
    return {
      autoWatch: false,
      basePath: config.app.dir,
      browsers: config.test.client.browsers,
      frameworks: ['jasmine', 'jasmine-matchers'],
      port: config.ports.test,
      reporters: ['dots'],
      singleRun: true
    };
  };
  formatScripts = function(_scripts) {
    var i, isAppScript, isTest, len, script, scripts, tests, watched;
    scripts = [];
    tests = config.glob.dist.app.client.test.js[0];
    for (i = 0, len = _scripts.length; i < len; i++) {
      script = _scripts[i];
      isTest = script.indexOf(config.dist.app.client.test.dir) !== -1;
      if (isTest) {
        continue;
      }
      isAppScript = script.indexOf(config.dist.app.client.scripts.dir) !== -1;
      watched = isAppScript;
      scripts.push({
        watched: watched,
        pattern: script
      });
    }
    scripts.push({
      watched: true,
      pattern: tests
    });
    return scripts;
  };
  updateTestResults = function(results) {
    TestResults.status = !!results.exitCode ? 'failed' : 'passed';
    TestResults.total = results.success + results.failed;
    TestResults.passed = results.success;
    TestResults.failed = results.failed;
    return TestResults;
  };
  hasTestsCheck = function(cnt) {
    if (cnt) {
      return true;
    }
    console.log('no test scripts to run'.yellow);
    return false;
  };
  startKarmaServer = function(karmaConfig, defer) {
    var server;
    server = new Server(karmaConfig, function(exitCode) {});
    server.start();
    server.on('run_complete', function(browsers, results) {
      updateTestResults(results);
      return defer.resolve();
    });
    return server;
  };
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
  runTests = function() {
    var defer, karmaConfig, testCnt, tests;
    defer = q.defer();
    tests = getTestsFile();
    karmaConfig = getKarmaConfig();
    testCnt = tests.scriptsTestCount;
    if (!hasTestsCheck(testCnt)) {
      return promiseHelp.get(defer);
    }
    karmaConfig.files = tests.scripts;
    startKarmaServer(karmaConfig, defer);
    return defer.promise;
  };
  runDevTests = function() {
    var defer, karmaConfig, testCnt, tests;
    defer = q.defer();
    tests = getTestsFile();
    karmaConfig = getKarmaConfig();
    testCnt = tests.scriptsTestCount;
    karmaConfig.files = formatScripts(tests.scripts);
    karmaConfig.autoWatch = true;
    karmaConfig.singleRun = false;
    startKarmaServer(karmaConfig, defer);
    return defer.promise;
  };
  writeResultsFile = function(file) {
    if (TestResults.status !== 'failed') {
      return promiseHelp.get();
    }
    fs.writeFileSync(file, format.json(TestResults));
    return promiseHelp.get();
  };
  failureCheck = function() {
    if (TestResults.status === 'passed') {
      return promiseHelp.get();
    }
    return process.on('exit', function() {
      var msg;
      msg = "Client test failed - created " + resultsFile;
      return console.error(msg.error);
    }).exit(1);
  };
  runDefaultTask = function() {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return cleanResultsFile(resultsFile);
      }, function() {
        return runTests();
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
  runDevTask = function() {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return cleanResultsFile(resultsFile);
      }, function() {
        return runDevTests();
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function(env) {
      if (!config.build.client) {
        return promiseHelp.get();
      }
      if (config.exclude.angular.files) {
        return promiseHelp.get();
      }
      if (env === 'dev') {
        return runDevTask();
      }
      return runDefaultTask();
    }
  };
  return api.runTask(taskOpts.env);
};
