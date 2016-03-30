module.exports = function(config, gulp, taskOpts) {
  var api, babel, babelOpts, coffee, coffeeTask, compileWatchFile, es2015, es6Task, forWatchFile, jsTask, plumber, q, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  babel = require('gulp-babel');
  coffee = require('gulp-coffee');
  plumber = require('gulp-plumber');
  es2015 = require('babel-preset-es2015');
  tasks = require(config.req.helpers + "/tasks")(config);
  babelOpts = {
    presets: [es2015]
  };
  forWatchFile = !!taskOpts.watchFile;
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
    gulp.src(src).pipe(plumber()).pipe(babel(babelOpts)).pipe(gulp.dest(dest)).on('end', function() {
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
        }
      ];
      _tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    },
    runMulti: function() {
      var defer;
      defer = q.defer();
      q.all([tasks.run.async(coffeeTask, 'test', 'coffee', ['client']), tasks.run.async(es6Task, 'test', 'es6', ['client']), tasks.run.async(jsTask, 'test', 'js', ['client'])]).done(function() {
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
