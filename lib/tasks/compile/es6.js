module.exports = function(config, gulp, taskOpts) {
  var api, babel, babelOpts, es2015, forWatchFile, plumber, q, runTask, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  babel = require('gulp-babel');
  plumber = require('gulp-plumber');
  es2015 = require('babel-preset-es2015');
  tasks = require(config.req.helpers + "/tasks")(config);
  forWatchFile = !!taskOpts.watchFile;
  babelOpts = {
    presets: [es2015]
  };
  runTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(plumber()).pipe(babel(babelOpts)).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      return runTask(taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir);
    },
    runMulti: function(loc) {
      return tasks.run.async(runTask, 'scripts', 'es6', [loc]);
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti(taskOpts.loc);
};
