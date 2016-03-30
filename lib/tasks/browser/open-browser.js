module.exports = function(config) {
  var api, open, promiseHelp, q;
  q = require('q');
  open = require('open');
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function(port) {
      var defer;
      defer = q.defer();
      open("http://localhost:" + port + "/", function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (!config.build.server) {
    return promiseHelp.get();
  }
  if (config.exclude["default"].server.files) {
    return promiseHelp.get();
  }
  if (!config.browser.open) {
    return promiseHelp.get();
  }
  return api.runTask(config.ports.server);
};
