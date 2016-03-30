module.exports = function(config, gulp, taskOpts) {
  var api, cleanRbClient, configHelp, del, promiseHelp, q, rebuildConfig;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  del = require('del');
  promiseHelp = require(config.req.helpers + "/promise");
  configHelp = require(config.req.helpers + "/config")(config);
  cleanRbClient = function() {
    var defer, src;
    defer = q.defer();
    src = config.dist.rb.client.dir;
    del(src, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  rebuildConfig = function(env) {
    if (env === 'test') {
      return promiseHelp.get();
    }
    if (config.spa.custom) {
      return promiseHelp.get();
    }
    if (config.exclude.spa) {
      return promiseHelp.get();
    }
    config.exclude.spa = true;
    return configHelp.buildFile(true, 'rebuild');
  };
  api = {
    runTask: function(env) {
      var defer;
      defer = q.defer();
      q.all([cleanRbClient(), rebuildConfig(env)]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (!config.exclude["default"].client.files) {
    return promiseHelp.get();
  }
  return api.runTask(taskOpts.env);
};
