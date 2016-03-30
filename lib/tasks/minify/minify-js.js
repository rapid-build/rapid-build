module.exports = function(config, gulp) {
  var api, gulpif, minifyJs, q, runTask;
  q = require('q');
  gulpif = require('gulp-if');
  minifyJs = require('gulp-uglify');
  runTask = function(appOrRb) {
    var defer, dest, minOpts, minify, src;
    defer = q.defer();
    minify = config.minify.js.scripts;
    minOpts = {
      mangle: config.minify.js.mangle
    };
    src = config.glob.dist[appOrRb].client.scripts.all;
    dest = config.dist[appOrRb].client.scripts.dir;
    src.push('!**/*.json');
    gulp.src(src).pipe(gulpif(minify, minifyJs(minOpts))).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("minified " + appOrRb + " dist scripts").yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      q.all([runTask('rb'), runTask('app')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
