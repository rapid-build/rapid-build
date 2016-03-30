module.exports = function(config, gulp, taskOpts) {
  var api, extraHelp, q, runTask;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  extraHelp = require(config.req.helpers + "/extra")(config);
  runTask = function(src, dest, base, appOrRb, loc) {
    var defer;
    defer = q.defer();
    gulp.src(src, {
      base: base,
      buffer: false
    }).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("copied extra files to " + appOrRb + " " + loc).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function(loc) {
      return extraHelp.run.tasks.async(runTask, 'copy', null, [loc]);
    }
  };
  return api.runTask(taskOpts.loc);
};
