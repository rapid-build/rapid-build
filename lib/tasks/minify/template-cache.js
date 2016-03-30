module.exports = function(config, gulp, taskOpts) {
  var addToDistPath, api, dirHelper, es, forWatchFile, getAppOrRb, getGlob, getRoot, glob, gulpif, minifyHtml, ngFormify, path, q, run, runNgFormify, runTask, templateCache;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  path = require('path');
  es = require('event-stream');
  gulpif = require('gulp-if');
  minifyHtml = require('gulp-htmlmin');
  templateCache = require('gulp-angular-templatecache');
  ngFormify = require(config.req.plugins + "/gulp-ng-formify");
  dirHelper = require(config.req.helpers + "/dir")(config, gulp);
  runNgFormify = config.angular.ngFormify;
  forWatchFile = !!taskOpts.watchFile;
  getGlob = function(loc, type, lang) {
    return config.glob.src[loc].client[type][lang];
  };
  glob = {
    views: {
      rb: getGlob('rb', 'views', 'html'),
      app: getGlob('app', 'views', 'html')
    }
  };
  getAppOrRb = function(base, loc, type) {
    if (!base) {
      return;
    }
    if (base.indexOf(config[loc].rb.client[type].dir) !== -1) {
      return 'rb';
    }
    return 'app';
  };
  getRoot = function() {
    var prefix, useAbsolutePaths;
    useAbsolutePaths = config.angular.templateCache.useAbsolutePaths;
    prefix = config.angular.templateCache.urlPrefix;
    if (useAbsolutePaths && prefix[0] !== '/') {
      prefix = "/" + prefix;
    }
    return prefix;
  };
  addToDistPath = function() {
    var transform;
    transform = function(file, cb) {
      var appOrRb, dirName, modPath, relPath;
      appOrRb = getAppOrRb(file.base, 'src', 'views');
      dirName = config.dist[appOrRb].client.views.dirName;
      if (appOrRb === 'rb') {
        dirName = path.join(config.rb.prefix.distDir, dirName);
      }
      relPath = path.join(dirName, file.relative);
      modPath = path.join(file.base, relPath);
      file.path = modPath;
      return cb(null, file);
    };
    return es.map(transform);
  };
  runTask = function(src, dest, file, isProd) {
    var defer, minOpts, minify, opts;
    defer = q.defer();
    minify = isProd && config.minify.html.views;
    minOpts = config.minify.html.options;
    opts = {};
    opts.root = getRoot();
    opts.module = config.angular.moduleName;
    gulp.src(src).pipe(addToDistPath()).pipe(gulpif(minify, minifyHtml(minOpts))).pipe(gulpif(runNgFormify, ngFormify())).pipe(templateCache(file, opts)).pipe(gulp.dest(dest)).on('end', function() {
      console.log(("created " + file).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  run = function() {
    var defer, dest, file, isProd, src;
    defer = q.defer();
    isProd = config.env.is.prod;
    file = isProd ? 'min' : 'main';
    file = config.fileName.views[file];
    dest = config.dist.rb.client.scripts.dir;
    src = [].concat(glob.views.rb, glob.views.app);
    dirHelper.hasFiles(src).done(function(hasFiles) {
      if (!hasFiles) {
        return defer.resolve();
      }
      return runTask(src, dest, file, isProd).done(function() {
        return defer.resolve();
      });
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      return run();
    },
    runMulti: function() {
      return run();
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
