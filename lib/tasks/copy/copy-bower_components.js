module.exports = function(config, gulp) {
  var addDistBasePath, api, bowerHelper, es, getComponents, getExcludeFromDist, path, promiseHelp, q, removeMin, runTask;
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
  getExcludeFromDist = function(appOrRb) {
    var excludes;
    excludes = config.exclude[appOrRb].from.dist.client;
    if (!Object.keys(excludes).length) {
      return [];
    }
    if (!excludes.bower) {
      return [];
    }
    return excludes.bower.all;
  };
  runTask = function(src, dest, appOrRb) {
    var absSrc, defer, excludes;
    defer = q.defer();
    if (!src || !src.paths.absolute.length) {
      return promiseHelp.get(defer);
    }
    absSrc = src.paths.absolute;
    excludes = getExcludeFromDist(appOrRb);
    absSrc = absSrc.concat(excludes);
    gulp.src(absSrc).pipe(addDistBasePath(src.paths.relative)).pipe(removeMin()).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  getComponents = function(appOrRb, exclude) {
    if (exclude) {
      return promiseHelp.get();
    }
    return runTask(bowerHelper.get.src(appOrRb), config.dist[appOrRb].client.bower.dir, appOrRb);
  };
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      q.all([getComponents('rb', config.exclude.angular.files), getComponents('app')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
