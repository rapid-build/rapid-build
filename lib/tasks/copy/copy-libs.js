module.exports = function(config, gulp) {
  var api, q, runTask;
  q = require('q');
  runTask = function(src, dest, appOrRb) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      q.all([runTask(config.glob.src.rb.client.libs.all, config.dist.rb.client.libs.dir, 'rb'), runTask(config.glob.src.app.client.libs.all, config.dist.app.client.libs.dir, 'app')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
