module.exports = function(config, gulp) {
  var addDistBasePath, api, bowerHelper, copyTask, es, path, promiseHelp, q, removeMin;
  q = require('q');
  path = require('path');
  es = require('event-stream');
  promiseHelp = require(config.req.helpers + "/promise");
  bowerHelper = require(config.req.helpers + "/bower")(config);
  removeMin = function() {
    var transform;
    transform = function(file, cb) {
      file.path = file.path.replace('.min', '');
      return cb(null, file);
    };
    return es.map(transform);
  };
  addDistBasePath = function(relPaths) {
    var transform;
    transform = function(file, cb) {
      var dir, name, relPath;
      relPath = relPaths[file.path];
      name = path.basename(relPath);
      dir = path.dirname(relPath);
      file.path = path.join(file.base, dir, name);
      return cb(null, file);
    };
    return es.map(transform);
  };
  copyTask = function(src, dest) {
    var defer;
    if (!src || !src.paths.absolute.length) {
      return promiseHelp.get();
    }
    defer = q.defer();
    gulp.src(src.paths.absolute).pipe(addDistBasePath(src.paths.relative)).pipe(removeMin()).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var dest, src;
      if (config.angular.httpBackend.enabled) {
        return promiseHelp.get();
      }
      src = bowerHelper.get.src('rb', {
        pkg: 'angular-mocks',
        test: true
      });
      dest = config.src.rb.client.test.dir;
      return copyTask(src, dest);
    }
  };
  return api.runTask();
};
