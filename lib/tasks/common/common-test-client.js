module.exports = function(config, gulp, taskOpts) {
  var api, gulpSequence, promiseHelp;
  if (taskOpts == null) {
    taskOpts = {};
  }
  gulpSequence = require('gulp-sequence').use(gulp);
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function(cb) {
      if (!config.build.client) {
        return promiseHelp.get();
      }
      if (config.exclude.angular.files) {
        return promiseHelp.get();
      }
      return gulpSequence(config.rb.prefix.task + "find-open-port:test:client", config.rb.prefix.task + "clean-rb-client-test-src", [config.rb.prefix.task + "build-inject-angular-mocks", config.rb.prefix.task + "copy-angular-mocks"], config.rb.prefix.task + "copy-client-tests", config.rb.prefix.task + "clean-rb-client:test", config.rb.prefix.task + "build-client-test-files", cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
