module.exports = function(config, gulp, taskOpts) {
  var api, babel, coffee, coffeeTask, compileWatchFile, es6Task, forWatchFile, jsTask, plumber, promiseHelp, q, runTest, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  babel = require('gulp-babel');
  coffee = require('gulp-coffee');
  plumber = require('gulp-plumber');
  promiseHelp = require(config.req.helpers + "/promise");
  tasks = require(config.req.helpers + "/tasks")(config);
  forWatchFile = !!taskOpts.watchFile;
  if (forWatchFile) {
    runTest = require(config.req.tasks + "/test/server/run-server-tests");
  }
  coffeeTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(plumber()).pipe(coffee({
      bare: true
    })).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  es6Task = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(plumber()).pipe(babel()).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  jsTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  compileWatchFile = function() {
    var dest, ext, src;
    ext = taskOpts.watchFile.extname.replace('.', '');
    src = taskOpts.watchFile.path;
    dest = taskOpts.watchFile.rbDistDir;
    switch (ext) {
      case 'js':
        return jsTask(src, dest);
      case 'es6':
        return es6Task(src, dest);
      case 'coffee':
        return coffeeTask(src, dest);
    }
  };
  api = {
    runSingle: function() {
      var _tasks, defer;
      defer = q.defer();
      _tasks = [
        function() {
          return compileWatchFile();
        }, function() {
          return runTest(config, gulp, {
            watchFilePath: taskOpts.watchFile.rbDistPath
          });
        }
      ];
      _tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    },
    runMulti: function() {
      var defer;
      if (!config.build.server) {
        return promiseHelp.get();
      }
      defer = q.defer();
      q.all([tasks.run.async(coffeeTask, 'test', 'coffee', ['server']), tasks.run.async(es6Task, 'test', 'es6', ['server']), tasks.run.async(jsTask, 'test', 'js', ['server'])]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
