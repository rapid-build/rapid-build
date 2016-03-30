module.exports = function(config, gulp, taskOpts) {
  var api, gulpSequence, promiseHelp;
  if (taskOpts == null) {
    taskOpts = {};
  }
  gulpSequence = require('gulp-sequence').use(gulp);
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function(cb) {
      if (!config.build.server) {
        return promiseHelp.get();
      }
      return gulpSequence(config.rb.prefix.task + "copy-server-tests", config.rb.prefix.task + "run-server-tests", cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
