module.exports = function(config, gulp) {
  var getTaskDeps, getTasks, isType, prefixTaskDeps, q;
  if (gulp == null) {
    gulp = {};
  }
  q = require('q');
  isType = require(config.req.helpers + "/isType");
  getTasks = function(tasksCb, type, lang, locs) {
    var tasks;
    tasks = [];
    locs.forEach(function(v1) {
      return ['rb', 'app'].forEach(function(v2) {
        return tasks.push({
          src: config.glob.src[v2][v1][type][lang],
          dest: config.dist[v2][v1][type].dir
        });
      });
    });
    tasks.forEach(function(v, i) {
      return tasks[i] = function() {
        return tasksCb(v.src, v.dest);
      };
    });
    return tasks;
  };
  prefixTaskDeps = function(deps) {
    var dep;
    deps = (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = deps.length; j < len; j++) {
        dep = deps[j];
        results.push(dep = "" + config.rb.prefix.task + dep);
      }
      return results;
    })();
    return deps;
  };
  getTaskDeps = function(deps) {
    if (deps == null) {
      deps = [];
    }
    if (!deps.length) {
      return [];
    }
    deps = prefixTaskDeps(deps);
    return deps;
  };
  return {
    run: {
      async: function(tasksCb, type, lang, locs) {
        var defer, promises, tasks;
        tasks = getTasks(tasksCb, type, lang, locs);
        defer = q.defer();
        promises = tasks.map(function(task) {
          return task();
        });
        q.all(promises).done(function() {
          return defer.resolve();
        });
        return defer.promise;
      },
      sync: function(tasksCb, type, lang, locs) {
        var defer, tasks;
        tasks = getTasks(tasksCb, type, lang, locs);
        defer = q.defer();
        tasks.reduce(q.when, q()).done(function() {
          return defer.resolve();
        });
        return defer.promise;
      }
    },
    wasCalledFrom: function(taskName) {
      var calledFromTask;
      calledFromTask = gulp.seq.indexOf(taskName) !== -1;
      return calledFromTask;
    },
    startTask: function(taskName) {
      return gulp.start("" + config.rb.prefix.task + taskName);
    },
    addTask: function(taskName, _path, opts) {
      var deps;
      if (opts == null) {
        opts = {};
      }
      deps = getTaskDeps(opts.deps);
      return gulp.task("" + config.rb.prefix.task + taskName, deps, function(cb) {
        var task;
        task = require("" + config.req.tasks + _path);
        if (opts.taskCB) {
          opts.taskCB = cb;
        }
        if (isType["function"](task)) {
          return task(config, gulp, opts);
        }
        return task[opts.run](config, gulp, opts);
      });
    }
  };
};
