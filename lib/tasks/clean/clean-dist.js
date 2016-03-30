module.exports = function(config, gulp, taskOpts) {
  var api, del, forWatchFile, q;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  del = require('del');
  forWatchFile = !!taskOpts.watchFile;
  api = {
    runSingle: function() {
      var defer, src;
      defer = q.defer();
      src = taskOpts.watchFile.rbDistPath;
      del(src, {
        force: true
      }).then(function(paths) {
        return defer.resolve();
      });
      return defer.promise;
    },
    runMulti: function() {
      var defer;
      defer = q.defer();
      del(config.dist.dir, {
        force: true
      }).then(function(paths) {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
