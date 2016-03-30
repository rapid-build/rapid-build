module.exports = function(config) {
  var api, del, q;
  q = require('q');
  del = require('del');
  api = {
    runTask: function(src) {
      var defer;
      defer = q.defer();
      del(src, {
        force: true
      }).then(function(paths) {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask(config.generated.pkg.files.files);
};
