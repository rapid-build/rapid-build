module.exports = function(config, gulp, taskOpts) {
  var api, gulpSequence, promiseHelp;
  if (taskOpts == null) {
    taskOpts = {};
  }
  gulpSequence = require('gulp-sequence').use(gulp);
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function(cb, env) {
      var serverTask;
      if (!config.build.server) {
        return promiseHelp.get();
      }
      if (config.exclude["default"].server.files) {
        return promiseHelp.get();
      }
      serverTask = env === 'dev' ? 'nodemon' : 'spawn-server';
      return gulpSequence("" + config.rb.prefix.task + serverTask, cb);
    }
  };
  return api.runTask(taskOpts.taskCB, taskOpts.env);
};
