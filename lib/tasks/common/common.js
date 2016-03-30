module.exports = function(config, gulp, taskOpts) {
  var api, gulpSequence, promiseHelp;
  if (taskOpts == null) {
    taskOpts = {};
  }
  if (!taskOpts.cnt) {
    taskOpts.cnt = 1;
  }
  gulpSequence = require('gulp-sequence').use(gulp);
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function(cb) {
      if (taskOpts.cnt > 1) {
        return promiseHelp.get();
      }
      taskOpts.cnt++;
      return gulpSequence(config.rb.prefix.task + "set-env-config", config.rb.prefix.task + "clean-dist", config.rb.prefix.task + "generate-pkg", config.rb.prefix.task + "build-config", cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
