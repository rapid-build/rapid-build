module.exports = function(config, gulp) {
  var api, getMode, promiseHelp;
  promiseHelp = require(config.req.helpers + "/promise");
  getMode = function(mode) {
    if (!mode) {
      return;
    }
    return mode.split(':').slice(1).join(':');
  };
  api = {
    runTask: function() {
      var mode;
      if (config.env.override) {
        return promiseHelp.get();
      }
      mode = gulp.seq[2];
      if (gulp.seq[3] === config.rb.tasks['prod:server']) {
        mode = gulp.seq[3];
      }
      mode = getMode(mode);
      config.env.set(mode);
      return promiseHelp.get();
    }
  };
  return api.runTask();
};
