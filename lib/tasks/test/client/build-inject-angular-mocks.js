module.exports = function(config, gulp) {
  var api, buildTask, getData, path, promiseHelp, q, rename, template;
  q = require('q');
  path = require('path');
  rename = require('gulp-rename');
  template = require('gulp-template');
  promiseHelp = require(config.req.helpers + "/promise");
  getData = function() {
    var data;
    return data = {
      moduleName: config.angular.moduleName
    };
  };
  buildTask = function(src, dest, file, data) {
    var defer;
    if (data == null) {
      data = {};
    }
    defer = q.defer();
    gulp.src(src).pipe(rename(file)).pipe(template(data)).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var data, dest, file, src;
      if (config.angular.httpBackend.enabled) {
        return promiseHelp.get();
      }
      data = getData();
      src = path.join(config.templates.dir, 'inject-angular-mocks.tpl');
      dest = config.src.rb.client.test.dir;
      file = 'inject-angular-mocks.coffee';
      return buildTask(src, dest, file, data);
    }
  };
  return api.runTask();
};
