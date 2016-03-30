module.exports = function(config, gulp, taskOpts) {
  var absCssUrls, api, forWatchFile, q, runTask, tasks;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  tasks = require(config.req.helpers + "/tasks")(config);
  forWatchFile = !!taskOpts.watchFile;
  if (forWatchFile) {
    absCssUrls = require(config.req.tasks + "/format/absolute-css-urls");
  }
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
      var _tasks, defer;
      defer = q.defer();
      _tasks = [
        function() {
          return runTask(taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir);
        }, function() {
          return absCssUrls(config, gulp, {
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
      return tasks.run.async(runTask, 'styles', 'css', ['client']);
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
