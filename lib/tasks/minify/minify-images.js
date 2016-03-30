module.exports = function(config, gulp) {
  var api, moveTask, path, q;
  q = require('q');
  path = require('path');
  moveTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      console.log("copied rb images".yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var dest, src;
      src = config.glob.dist.rb.client.images.all + "/*";
      dest = path.join(config.temp.client.dir, config.rb.prefix.distDir, config.dist.rb.client.images.dirName);
      return moveTask(src, dest);
    }
  };
  return api.runTask();
};
