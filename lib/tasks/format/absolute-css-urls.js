module.exports = function(config, gulp, taskOpts) {
  var absCssUrls, api, arrayHelp, buildConfigFile, buildSpa, configHelp, forWatchFile, promiseHelp, q, runMulti, runTask, setBuildConfigFile, taskHelp;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  absCssUrls = require(config.req.plugins + "/gulp-absolute-css-urls");
  arrayHelp = require(config.req.helpers + "/array");
  promiseHelp = require(config.req.helpers + "/promise");
  configHelp = require(config.req.helpers + "/config")(config);
  taskHelp = require(config.req.helpers + "/tasks")(config, gulp);
  forWatchFile = !!taskOpts.watchFilePath;
  buildConfigFile = false;
  setBuildConfigFile = function() {
    buildConfigFile = !!config.internal.getImports().length;
    return promiseHelp.get();
  };
  buildSpa = function() {
    return taskHelp.startTask('watch-build-spa');
  };
  runTask = function(appOrRb, type, opts) {
    var base, clientDist, defer, dest, glob, src, urlOpts;
    if (opts == null) {
      opts = {};
    }
    defer = q.defer();
    glob = opts.glob || 'css';
    src = opts.src || config.glob.dist[appOrRb].client[type][glob];
    dest = config.dist[appOrRb].client[type].dir;
    base = opts.watchFileBase ? dest : '';
    clientDist = config.dist.app.client.dir;
    urlOpts = {};
    urlOpts.rbDistDir = config.rb.prefix.distDir;
    urlOpts.prependPath = opts.prependPath;
    gulp.src(src, {
      base: base
    }).pipe(absCssUrls(clientDist, config, urlOpts)).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  runMulti = function() {
    var defer;
    defer = q.defer();
    q.all([
      runTask('rb', 'bower'), runTask('rb', 'libs'), runTask('rb', 'styles', {
        prependPath: false,
        glob: 'all'
      }), runTask('app', 'bower'), runTask('app', 'libs'), runTask('app', 'styles', {
        prependPath: false,
        glob: 'all'
      })
    ]).done(function() {
      console.log('changed all css urls to absolute'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      var clone, opts;
      clone = config.internal.getImports();
      opts = {
        prependPath: false,
        src: taskOpts.watchFilePath,
        watchFileBase: true
      };
      return runTask('app', 'styles', opts).done(function() {
        var areEqual, imports;
        imports = config.internal.getImports();
        areEqual = arrayHelp.areEqual(clone, imports, true);
        if (!areEqual) {
          return buildSpa();
        }
      });
    },
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return runMulti();
        }, function() {
          return setBuildConfigFile();
        }, function() {
          return configHelp.buildFile(buildConfigFile, 'rebuild');
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runTask();
};
