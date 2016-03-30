module.exports = function(config, gulp, taskOpts) {
  var api, coffee, extraHelp, plumber, q, runTask;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  coffee = require('gulp-coffee');
  plumber = require('gulp-plumber');
  extraHelp = require(config.req.helpers + "/extra")(config);
  runTask = function(src, dest, base, appOrRb, loc) {
    var defer;
    defer = q.defer();
    gulp.src(src, {
      base: base
    }).pipe(plumber()).pipe(coffee({
      bare: true
    })).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("compiled extra coffee to " + appOrRb + " " + loc).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function(loc) {
      return extraHelp.run.tasks.async(runTask, 'compile', 'coffee', [loc]);
    }
  };
  return api.runTask(taskOpts.loc);
};
