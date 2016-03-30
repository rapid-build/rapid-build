module.exports = function(config, gulp, taskOpts) {
  var api, gulpSequence;
  if (taskOpts == null) {
    taskOpts = {};
  }
  gulpSequence = require('gulp-sequence').use(gulp);
  api = {
    runTask: function(cb) {
      return gulpSequence(config.rb.prefix.task + "build-files", config.rb.prefix.task + "build-spa", cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
