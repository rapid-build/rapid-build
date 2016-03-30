module.exports = function(config, gulp, taskOpts) {
  var api, forWatchFile, gulpif, ngFormify, q, runNgFormify, runTask, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  gulpif = require('gulp-if');
  ngFormify = require(config.req.plugins + "/gulp-ng-formify");
  tasks = require(config.req.helpers + "/tasks")(config);
  runNgFormify = config.angular.ngFormify;
  forWatchFile = !!taskOpts.watchFile;
  runTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(gulpif(runNgFormify, ngFormify())).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      return runTask(taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir);
    },
    runMulti: function() {
      return tasks.run.async(runTask, 'views', 'html', ['client']);
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
