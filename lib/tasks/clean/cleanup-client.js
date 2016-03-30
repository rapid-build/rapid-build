module.exports = function(config, gulp) {
  var Blueprint, api, cleanCssImportsTask, cleanTask, del, delEmptyDirsTask, delTask, dirHelper, log, moveTempTask, multiCleanTask, path, promiseHelp, q, setBlueprint;
  q = require('q');
  del = require('del');
  path = require('path');
  log = require(config.req.helpers + "/log");
  promiseHelp = require(config.req.helpers + "/promise");
  dirHelper = require(config.req.helpers + "/dir")(config, gulp);
  Blueprint = {};
  cleanTask = function(type) {
    var defer1, file, fn, i, j, len, ref, tasks;
    defer1 = q.defer();
    tasks = [];
    ref = Blueprint[type];
    fn = function(file) {
      return tasks.push(function() {
        return delTask(file.files);
      });
    };
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      file = ref[i];
      if (file.type === 'exclude') {
        continue;
      }
      fn(file);
    }
    tasks.reduce(q.when, q()).done(function() {
      return defer1.resolve();
    });
    return defer1.promise;
  };
  setBlueprint = function() {
    var file;
    file = config.generated.pkg.files.prodFilesBlueprint;
    Blueprint = require(file);
    return promiseHelp.get();
  };
  multiCleanTask = function(msg) {
    var defer;
    defer = q.defer();
    q.all([cleanTask('scripts'), cleanTask('styles')]).done(function() {
      if (msg) {
        console.log(msg.yellow);
      }
      return defer.resolve();
    });
    return defer.promise;
  };
  cleanCssImportsTask = function(msg) {
    var defer;
    defer = q.defer();
    q.all([delTask(config.internal.getImportsAppOrRb('rb')), delTask(config.internal.getImportsAppOrRb('app'))]).done(function() {
      if (msg) {
        console.log(msg.yellow);
      }
      return defer.resolve();
    });
    return defer.promise;
  };
  moveTempTask = function(msg) {
    var defer, dest, src;
    defer = q.defer();
    src = config.temp.client.glob;
    dest = config.dist.app.client.dir;
    gulp.src(src).pipe(gulp.dest(dest)).on('end', function() {
      if (msg) {
        console.log(msg.yellow);
      }
      return defer.resolve();
    });
    return defer.promise;
  };
  delTask = function(src, msg) {
    var defer;
    defer = q.defer();
    del(src, {
      force: true
    }).then(function(paths) {
      if (msg) {
        console.log(msg.yellow);
      }
      return defer.resolve();
    });
    return defer.promise;
  };
  delEmptyDirsTask = function(msg) {
    var emptyDirs;
    emptyDirs = dirHelper.get.emptyDirs(config.dist.app.client.dir, [], 'reverse');
    if (!emptyDirs.length) {
      return promiseHelp.get();
    }
    return delTask(emptyDirs, msg);
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return setBlueprint();
        }, function() {
          return multiCleanTask('cleaned client min files');
        }, function() {
          return cleanCssImportsTask('cleaned css imports');
        }, function() {
          return moveTempTask('moved .temp files to client root');
        }, function() {
          return delTask(config.temp.client.dir, 'deleted .temp directory');
        }, function() {
          return delEmptyDirsTask('deleted empty directories');
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
