module.exports = function(config, gulp) {
  var api, promiseHelp, q;
  q = require('q');
  promiseHelp = require(config.req.helpers + "/promise");
  api = {
    runTask: function() {
      var defer, dest, src;
      if (config.exclude["default"].server.files) {
        return promiseHelp.get();
      }
      defer = q.defer();
      src = config.generated.pkg.config;
      dest = config.dist.rb.server.scripts.dir;
      gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
