module.exports = function(config, gulp) {
  var api, minOpts, minifyCss, promiseHelp, q, runTask;
  q = require('q');
  minifyCss = require('gulp-cssnano');
  promiseHelp = require(config.req.helpers + "/promise");
  minOpts = {
    safe: true,
    mergeRules: false,
    normalizeUrl: false
  };
  runTask = function(appOrRb) {
    var defer, dest, src;
    defer = q.defer();
    src = config.glob.dist[appOrRb].client.styles.all;
    dest = config.dist[appOrRb].client.styles.dir;
    gulp.src(src).pipe(minifyCss(minOpts)).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("minified " + appOrRb + " dist styles").yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer;
      if (!config.minify.css.styles) {
        return promiseHelp.get();
      }
      defer = q.defer();
      q.all([runTask('rb'), runTask('app')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
