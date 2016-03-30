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
      if (!config.build.client) {
        return promiseHelp.get();
      }
      if (config.exclude.angular.files) {
        return promiseHelp.get();
      }
      src = [config.dist.rb.client.test.dir, config.dist.app.client.test.dir];
      return cleanTask(src);
    }
  };
  return api.runTask();
};
