module.exports = function(config, gulp) {
  var api, minJsTask, minJsonTask, minifyJs, minifyJson, promiseHelp, q;
  q = require('q');
  minifyJs = require('gulp-uglify');
  minifyJson = require('gulp-jsonminify');
  promiseHelp = require(config.req.helpers + "/promise");
  minJsTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(minifyJs()).pipe(gulp.dest(dest)).on('end', function() {
      console.log("minified server js".yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  minJsonTask = function(src, dest) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(minifyJson()).pipe(gulp.dest(dest)).on('end', function() {
      console.log("minified server json".yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer, exclude, serverDist;
      if (!config.build.server) {
        return promiseHelp.get();
      }
      defer = q.defer();
      serverDist = config.dist.app.server.scripts.dir;
      exclude = '!**/node_modules/**';
      q.all([minJsTask([serverDist + "/**/*.js", exclude], serverDist), minJsonTask([serverDist + "/**/*.json", exclude], serverDist)]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
