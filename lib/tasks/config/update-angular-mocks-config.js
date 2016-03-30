module.exports = function(config) {
  var api, configHelp, promiseHelp, q, updateConfig;
  q = require('q');
  promiseHelp = require(config.req.helpers + "/promise");
  configHelp = require(config.req.helpers + "/config")(config);
  updateConfig = function() {
    config.angular.removeRbMocksModule();
    config.angular.updateHttpBackendStatus();
    config.order.removeRbAngularMocks();
    config.glob.removeRbAngularMocks();
    return promiseHelp.get();
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return updateConfig();
        }, function() {
          return configHelp.buildFile(true, 'rebuild');
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
