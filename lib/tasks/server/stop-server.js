module.exports = function(config) {
  var api, path, promiseHelp, q, stopServerFile;
  q = require('q');
  path = require('path');
  promiseHelp = require(config.req.helpers + "/promise");
  stopServerFile = path.join(config.dist.rb.server.scripts.path, 'stop-server.js');
  api = {
    runTask: function() {
      var defer, stopServer;
      if (!config.build.server) {
        return promiseHelp.get();
      }
      if (config.exclude["default"].server.files) {
        return promiseHelp.get();
      }
      defer = q.defer();
      stopServer = require(stopServerFile);
      stopServer().done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
