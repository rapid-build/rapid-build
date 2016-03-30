module.exports = function(config) {
  var api, ignoreDirs, nodemon, q, rbServerFile, watchDir;
  q = require('q');
  nodemon = require('gulp-nodemon');
  rbServerFile = config.dist.rb.server.scripts.filePath;
  watchDir = config.dist.app.server.scripts.dir;
  ignoreDirs = [config.node_modules.rb.dist.dir, config.node_modules.app.dist.dir, config.dist.rb.server.test.dir, config.dist.app.server.test.dir];
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      nodemon({
        script: rbServerFile,
        ext: 'js json',
        watch: watchDir,
        ignore: ignoreDirs
      }).on('start', function() {
        var browserSync;
        browserSync = require(config.req.tasks + "/browser/browser-sync");
        browserSync.delayedRestart();
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
