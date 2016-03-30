module.exports = function(config, gulp) {
  var api, minifyHtml, promiseHelp, q, runTask;
  q = require('q');
  minifyHtml = require('gulp-htmlmin');
  promiseHelp = require(config.req.helpers + "/promise");
  runTask = function(src, dest, file) {
    var defer, minOpts;
    defer = q.defer();
    minOpts = config.minify.html.options;
    gulp.src(src).pipe(minifyHtml(minOpts)).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("minified " + file).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      if (config.exclude.spa) {
        return promiseHelp.get();
      }
      if (!config.minify.spa.file) {
        return promiseHelp.get();
      }
      return runTask(config.spa.dist.path, config.dist.app.client.dir, config.spa.dist.file);
    }
  };
  return api.runTask();
};
