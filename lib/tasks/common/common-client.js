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
      return gulpSequence(config.rb.prefix.task + "update-angular-mocks-config", config.rb.prefix.task + "build-bower-json", config.rb.prefix.task + "bower", config.rb.prefix.task + "build-angular-modules", [config.rb.prefix.task + "copy-bower_components", config.rb.prefix.task + "copy-css", config.rb.prefix.task + "copy-images", config.rb.prefix.task + "copy-js:client", config.rb.prefix.task + "copy-libs", config.rb.prefix.task + "copy-views", config.rb.prefix.task + "coffee:client", config.rb.prefix.task + "es6:client", config.rb.prefix.task + "less", config.rb.prefix.task + "sass", config.rb.prefix.task + "compile-extra-coffee:client", config.rb.prefix.task + "compile-extra-es6:client", config.rb.prefix.task + "compile-extra-less:client", config.rb.prefix.task + "compile-extra-sass:client", config.rb.prefix.task + "copy-extra-files:client"], config.rb.prefix.task + "absolute-css-urls", config.rb.prefix.task + "clean-rb-client", config.rb.prefix.task + "build-files", cb);
    }
  };
  return api.runTask(taskOpts.taskCB);
};
