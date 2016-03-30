module.exports = function(config, gulp, taskOpts) {
  var api, extCss, extraHelp, path, plumber, q, runTask, sass;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  path = require('path');
  sass = require('gulp-sass');
  plumber = require('gulp-plumber');
  extraHelp = require(config.req.helpers + "/extra")(config);
  extCss = '.css';
  runTask = function(src, dest, base, appOrRb, loc) {
    var defer;
    defer = q.defer();
    gulp.src(src, {
      base: base
    }).pipe(plumber()).pipe(sass().on('data', function(file) {
      var ext;
      ext = path.extname(file.relative);
      if (ext !== extCss) {
        return file.path = file.path.replace(ext, extCss);
      }
    })).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("compiled extra sass to " + appOrRb + " " + loc).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function(loc) {
      return extraHelp.run.tasks.async(runTask, 'compile', 'sass', [loc]);
    }
  };
  return api.runTask(taskOpts.loc);
};
