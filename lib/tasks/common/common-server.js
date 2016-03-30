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
      return gulpSequence(config.rb.prefix.task + "find-open-port", [config.rb.prefix.task + "copy-js:server", config.rb.prefix.task + "coffee:server", config.rb.prefix.task + "es6:server", config.rb.prefix.task + "copy-server-config", config.rb.prefix.task + "copy-server-node_modules", config.rb.prefix.task + "compile-extra-less:server", config.rb.prefix.task + "compile-extra-sass:server", config.rb.prefix.task + "copy-extra-files:server"], cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
