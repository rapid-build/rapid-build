module.exports = function(config) {
  var api, cleanTask, del, promiseHelp, q;
  q = require('q');
  del = require('del');
  promiseHelp = require(config.req.helpers + "/promise");
  cleanTask = function(src) {
    var defer;
    defer = q.defer();
    del(src, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var src;
      if (!config.build.server) {
        return promiseHelp.get();
      }
      src = [config.dist.rb.server.test.dir, config.dist.app.server.test.dir, config.node_modules.rb.dist.modules['jasmine-expect']];
      return cleanTask(src);
    }
  };
  return api.runTask();
};
