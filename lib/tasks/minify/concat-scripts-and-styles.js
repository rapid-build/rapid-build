module.exports = function(config, gulp) {
  var Blueprint, api, cleanTask, concat, concatTask, del, log, multiConcatTask, path, promiseHelp, q, setBlueprint;
  q = require('q');
  del = require('del');
  path = require('path');
  concat = require('gulp-concat');
  log = require(config.req.helpers + "/log");
  promiseHelp = require(config.req.helpers + "/promise");
  Blueprint = {};
  concatTask = function(type) {
    var defer1, file, fn, i, j, len, ref, tasks;
    defer1 = q.defer();
    tasks = [];
    ref = Blueprint[type];
    fn = function(file) {
      return tasks.push(function() {
        var defer, dest, src;
        defer = q.defer();
        src = file.files;
        dest = config.temp.client[type].dir;
        gulp.src(src).pipe(concat(file.name)).pipe(gulp.dest(dest)).on('end', function() {
          console.log(("created " + file.name).yellow);
          return defer.resolve();
        });
        return defer.promise;
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
  cleanTask = function() {
    var defer, src;
    defer = q.defer();
    src = [config.temp.client['scripts'].dir, config.temp.client['styles'].dir];
    del(src, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  multiConcatTask = function() {
    var defer;
    defer = q.defer();
    q.all([concatTask('scripts'), concatTask('styles')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return setBlueprint();
        }, function() {
          return cleanTask();
        }, function() {
          return multiConcatTask();
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
