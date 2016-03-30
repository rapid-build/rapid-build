module.exports = function(config) {
  var api, q, rbServerFile;
  q = require('q');
  rbServerFile = config.dist.rb.server.scripts.filePath;
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      require(rbServerFile);
      defer.resolve();
      return defer.promise;
    }
  };
  return api.runTask();
};
