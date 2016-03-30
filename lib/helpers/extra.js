module.exports = function(config) {
  var getTasks, promiseHelp, q;
  q = require('q');
  promiseHelp = require(config.req.helpers + "/promise");
  getTasks = function(tasksCb, srcBase, srcTask, locs) {
    var _args, appOrRb, args, fn, i, j, k, l, len, len1, len2, loc, ref, src, tasks, v;
    args = [];
    tasks = [];
    ref = ['rb', 'app'];
    for (j = 0, len = ref.length; j < len; j++) {
      appOrRb = ref[j];
      for (k = 0, len1 = locs.length; k < len1; k++) {
        loc = locs[k];
        src = srcBase[appOrRb][loc];
        if (srcTask) {
          src = src[srcTask];
        }
        _args = {
          src: src,
          dest: config.dist[appOrRb][loc].dir,
          base: config.src[appOrRb][loc].dir,
          appOrRb: appOrRb,
          loc: loc
        };
        if (!_args.src) {
          continue;
        }
        if (!_args.src.length) {
          continue;
        }
        args.push(_args);
      }
    }
    if (!args.length) {
      return tasks;
    }
    fn = function(v) {
      return tasks[i] = function() {
        return tasksCb(v.src, v.dest, v.base, v.appOrRb, v.loc);
      };
    };
    for (i = l = 0, len2 = args.length; l < len2; i = ++l) {
      v = args[i];
      fn(v);
    }
    return tasks;
  };
  return {
    run: {
      tasks: {
        async: function(tasksCb, task, subTask, locs) {
          var defer, promises, tasks;
          defer = q.defer();
          tasks = getTasks(tasksCb, config.extra[task], subTask, locs);
          if (!tasks.length) {
            return promiseHelp.get(defer);
          }
          promises = tasks.map(function(_task) {
            return _task();
          });
          q.all(promises).done(function() {
            return defer.resolve();
          });
          return defer.promise;
        },
        sync: function(tasksCb, task, subTask, locs) {
          var defer, tasks;
          defer = q.defer();
          tasks = getTasks(tasksCb, config.extra[task], subTask, locs);
          if (!tasks.length) {
            return promiseHelp.get(defer);
          }
          tasks.reduce(q.when, q()).done(function() {
            return defer.resolve();
          });
          return defer.promise;
        }
      }
    }
  };
};
