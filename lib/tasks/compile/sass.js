module.exports = function(config, gulp, taskOpts) {
  var absCssUrls, addToDistPath, api, es, extCss, forWatchFile, getImports, getWatchSrc, gulpif, path, plumber, q, run, runTask, runWatch, sass, sassHelper;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  path = require('path');
  es = require('event-stream');
  gulpif = require('gulp-if');
  sass = require('gulp-sass');
  plumber = require('gulp-plumber');
  sassHelper = require(config.req.helpers + "/Sass")(config, gulp);
  forWatchFile = !!taskOpts.watchFile;
  if (forWatchFile) {
    absCssUrls = require(config.req.tasks + "/format/absolute-css-urls");
  }
  extCss = '.css';
  addToDistPath = function(appOrRb) {
    var transform;
    transform = function(file, cb) {
      var _path, basePath, basePathDup, fileName, relPath;
      fileName = path.basename(file.path);
      basePath = file.base.replace(config.src[appOrRb].client.styles.dir, '');
      basePathDup = path.join(basePath, basePath);
      relPath = path.join(basePathDup, file.relative);
      _path = path.join(config.src[appOrRb].client.styles.dir, relPath);
      file.path = _path;
      return cb(null, file);
    };
    return es.map(transform);
  };
  runTask = function(src, dest, appOrRb) {
    var defer;
    defer = q.defer();
    gulp.src(src).pipe(plumber()).pipe(sass().on('data', function(file) {
      var ext;
      ext = path.extname(file.relative);
      if (ext !== extCss) {
        return file.path = file.path.replace(ext, extCss);
      }
    })).pipe(gulpif(forWatchFile, addToDistPath(appOrRb))).pipe(gulp.dest(dest)).on('data', function(file) {
      var watchFilePath;
      if (!forWatchFile) {
        return;
      }
      watchFilePath = path.relative(file.cwd, file.path);
      return absCssUrls(config, gulp, {
        watchFilePath: watchFilePath
      });
    }).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  getImports = function(appOrRb) {
    var defer;
    defer = q.defer();
    new sassHelper(config.glob.src[appOrRb].client.styles.sass).setImports().then(function(me) {
      var imports;
      imports = me.getImports();
      return defer.resolve(imports);
    });
    return defer.promise;
  };
  getWatchSrc = function(appOrRb) {
    var defer;
    defer = q.defer();
    new sassHelper(config.glob.src[appOrRb].client.styles.sass).setImports().then(function(me) {
      var src;
      src = me.getWatchSrc(taskOpts.watchFile.path);
      return defer.resolve(src);
    });
    return defer.promise;
  };
  runWatch = function(appOrRb) {
    var defer;
    defer = q.defer();
    getWatchSrc(appOrRb).then(function(src) {
      var dest;
      dest = config.dist[appOrRb].client.styles.dir;
      return runTask(src, dest, appOrRb).done(function() {
        return defer.resolve();
      });
    });
    return defer.promise;
  };
  run = function(appOrRb) {
    var defer;
    defer = q.defer();
    getImports(appOrRb).then(function(imports) {
      var dest, src;
      dest = config.dist[appOrRb].client.styles.dir;
      src = config.glob.src[appOrRb].client.styles.sass;
      src = [].concat(src, imports);
      return runTask(src, dest).done(function() {
        return defer.resolve();
      });
    });
    return defer.promise;
  };
  api = {
    runSingle: function() {
      return runWatch(taskOpts.watchFile.rbAppOrRb);
    },
    runMulti: function() {
      var defer;
      defer = q.defer();
      q.all([run('app'), run('rb')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  if (forWatchFile) {
    return api.runSingle();
  }
  return api.runMulti();
};
