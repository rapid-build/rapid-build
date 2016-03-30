module.exports = function(gulp, options) {
  var bootstrap, config, promise, rbDir, tasks;
  if (options == null) {
    options = {};
  }
  rbDir = __dirname;
  if (!gulp) {
    gulp = require('gulp');
  }
  bootstrap = require(rbDir + "/bootstrap")();
  config = require(rbDir + "/config/config")(rbDir, options);
  tasks = require(config.req.init + "/tasks")(gulp, config);
  promise = require(config.req.init + "/api")(gulp, config);
  return function(env) {
    if (env == null) {
      env = 'default';
    }
    gulp.start(config.rb.tasks[env]);
    return promise;
  };
};
