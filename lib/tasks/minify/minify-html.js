module.exports = function(config, gulp) {
  var api, minifyHtml, minifyTask, minifyTasks, moveTask, path, promiseHelp, q;
  q = require('q');
  path = require('path');
  minifyHtml = require('gulp-htmlmin');
  promiseHelp = require(config.req.helpers + "/promise");
  minifyTask = function(appOrRb) {
    var defer, minOpts;
    defer = q.defer();
    if (!config.minify.html.views) {
      return promiseHelp.get(defer);
    }
    minOpts = config.minify.html.options;
    gulp.src(config.glob.dist[appOrRb].client.views.all).pipe(minifyHtml(minOpts)).pipe(gulp.dest(config.dist[appOrRb].client.views.dir)).on('end', function() {
      console.log(("minified " + appOrRb + " dist views").yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  minifyTasks = function() {
    var defer;
    defer = q.defer();
    q.all([minifyTask('rb'), minifyTask('app')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  moveTask = function() {
    var defer, dest, src;
    defer = q.defer();
    src = config.glob.dist.rb.client.views.all + "/*";
    dest = path.join(config.temp.client.dir, config.rb.prefix.distDir, config.dist.rb.client.views.dirName);
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      console.log("copied rb views".yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer;
      if (config.minify.html.templateCache) {
        return promiseHelp.get();
      }
      defer = q.defer();
      minifyTasks().done(function() {
        return moveTask().done(function() {
          return defer.resolve();
        });
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
