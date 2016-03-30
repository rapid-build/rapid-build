module.exports = function(config, gulp, taskOpts) {
  var api, forWatchFile, q, runTask, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  tasks = require(config.req.helpers + "/tasks")(config);
  forWatchFile = !!taskOpts.watchFile;
  runTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      return runTask(taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir);
    },
    runMulti: function(loc) {
      return tasks.run.async(runTask, 'scripts', 'js', [loc]);
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti(taskOpts.loc);
};
