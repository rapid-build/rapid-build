module.exports = function(config, gulp) {
  var api, getData, q, rename, template;
  q = require('q');
  rename = require('gulp-rename');
  template = require('gulp-template');
  getData = function() {
    var data;
    return data = {
      modules: config.angular.modules,
      moduleName: config.angular.moduleName
    };
  };
  api = {
    runTask: function(src, dest, file) {
      var data, defer;
      defer = q.defer();
      data = getData();
      gulp.src(src).pipe(rename(file)).pipe(template(data)).pipe(gulp.dest(dest)).on('end', function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask(config.templates.angularModules.src.path, config.templates.angularModules.dest.dir, config.templates.angularModules.dest.file);
};
