module.exports = function(config, gulp) {
  var Bust, api, bustOpts, del, getUnstampedPath, path, promiseHelp, q, runDelUnstampedPaths, runStampFiles, runStampRefs, unstampedPaths;
  q = require('q');
  del = require('del');
  path = require('path');
  Bust = require('gulp-cachebust');
  promiseHelp = require(config.req.helpers + "/promise");
  unstampedPaths = [];
  bustOpts = {
    checksumLength: 3
  };
  getUnstampedPath = function(_path) {
    var dir, end, ext, name;
    dir = path.dirname(_path);
    ext = path.extname(_path);
    name = path.basename(_path, ext);
    end = name.length - (bustOpts.checksumLength + 1);
    name = name.substring(0, end) + ext;
    return _path = path.join(dir, name);
  };
  runStampFiles = function(src, dest, bust) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(bust.resources()).on('data', function(file) {
      return unstampedPaths.push(getUnstampedPath(file.path));
    }).pipe(gulp.dest(dest)).on('end', function() {
      console.log('file names busted'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  runDelUnstampedPaths = function() {
    var defer;
    defer = q.defer();
    if (!unstampedPaths.length) {
      return promiseHelp.get(defer);
    }
    del(unstampedPaths, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  runStampRefs = function(src, dest, bust) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(bust.references()).pipe(gulp.dest(dest)).on('end', function() {
      console.log('file references busted'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var bust, defer, dest, prodFilesDest, prodFilesSrc, srcFiles, srcRefs, tasks;
      if (!config.minify.cacheBust) {
        return promiseHelp.get();
      }
      defer = q.defer();
      bust = new Bust(bustOpts);
      srcFiles = config.glob.dist.app.client.cacheBust.files;
      srcRefs = config.glob.dist.app.client.cacheBust.references;
      dest = config.dist.app.client.dir;
      prodFilesSrc = config.generated.pkg.files.prodFiles;
      prodFilesDest = config.generated.pkg.files.path;
      tasks = [
        function() {
          return runStampFiles(srcFiles, dest, bust);
        }, function() {
          return runStampRefs(srcRefs, dest, bust);
        }, function() {
          return runStampRefs(prodFilesSrc, prodFilesDest, bust);
        }, function() {
          return runDelUnstampedPaths();
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
