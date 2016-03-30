module.exports = function(config, gulp) {
  var ProdFiles, SplitFiles, api, bless, buildProdFiles, fs, fse, path, pathHelp, promiseHelp, q, rebuildProdFiles, runTask, splitTask, updateProdFiles, updateSplitFiles;
  q = require('q');
  fs = require('fs');
  fse = require('fs-extra');
  path = require('path');
  bless = require('gulp-bless');
  pathHelp = require(config.req.helpers + "/path");
  promiseHelp = require(config.req.helpers + "/promise");
  SplitFiles = [];
  ProdFiles = {};
  splitTask = function(src, dest, ext) {
    var defer, files, opts;
    defer = q.defer();
    opts = {
      imports: false,
      force: true
    };
    files = [];
    gulp.src(src).on('data', function(file) {
      var basename;
      basename = path.basename(file.path);
      return files.push({
        cnt: 0,
        name: basename,
        newPaths: []
      });
    }).pipe(bless(opts)).on('data', function(file) {
      var _file, basename, didSplit, isBlessedFile, total;
      total = files.length;
      basename = file.basename;
      if (!total) {
        return;
      }
      if (!basename) {
        return;
      }
      _file = files[total - 1];
      isBlessedFile = basename.indexOf('blessed') !== -1;
      didSplit = isBlessedFile || _file.cnt;
      if (!didSplit) {
        return;
      }
      if (!isBlessedFile) {
        fs.unlinkSync(file.path);
      }
      _file.cnt++;
      basename = path.basename(_file.name, ext);
      file.basename = basename + "." + _file.cnt + ext;
      return _file.newPaths.push(file.path);
    }).pipe(gulp.dest(dest)).on('end', function() {
      var file, j, len;
      for (j = 0, len = files.length; j < len; j++) {
        file = files[j];
        if (file.cnt) {
          SplitFiles.push(file);
          console.log((file.name + " split into " + file.cnt + " files").yellow);
        }
      }
      return defer.resolve();
    });
    return defer.promise;
  };
  updateSplitFiles = function() {
    var appDir, file, i, j, k, len, len1, ref, v;
    appDir = pathHelp.format(config.app.dir);
    for (j = 0, len = SplitFiles.length; j < len; j++) {
      file = SplitFiles[j];
      ref = file.newPaths;
      for (i = k = 0, len1 = ref.length; k < len1; i = ++k) {
        v = ref[i];
        file.newPaths[i] = pathHelp.format(v).replace(appDir + "/", '');
      }
    }
    return promiseHelp.get();
  };
  updateProdFiles = function() {
    var _path, dest, file, j, k, len, len1, match, ref, styles, v1, v2;
    dest = pathHelp.format(config.dist.app.client.styles.dir);
    file = config.generated.pkg.files.prodFiles;
    ProdFiles = require(file);
    styles = [];
    ref = ProdFiles.client.styles;
    for (j = 0, len = ref.length; j < len; j++) {
      v1 = ref[j];
      match = false;
      for (k = 0, len1 = SplitFiles.length; k < len1; k++) {
        v2 = SplitFiles[k];
        _path = dest + "/" + v2.name;
        if (v1.indexOf(_path) === -1) {
          continue;
        }
        match = true;
        styles = styles.concat(v2.newPaths);
        break;
      }
      if (!match) {
        styles.push(v1);
      }
    }
    ProdFiles.client.styles = styles;
    return promiseHelp.get();
  };
  buildProdFiles = function() {
    var defer, format, jsonFile;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    jsonFile = config.generated.pkg.files.prodFiles;
    fse.writeJson(jsonFile, ProdFiles, format, function(e) {
      console.log('rebuilt prod-files.json because of css file split'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  rebuildProdFiles = function() {
    var defer, tasks;
    if (!SplitFiles.length) {
      return promiseHelp.get();
    }
    defer = q.defer();
    tasks = [
      function() {
        return updateSplitFiles();
      }, function() {
        return updateProdFiles();
      }, function() {
        return buildProdFiles();
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  runTask = function(src, dest, ext) {
    var defer, tasks;
    defer = q.defer();
    tasks = [
      function() {
        return splitTask(src, dest, ext);
      }, function() {
        return rebuildProdFiles();
      }
    ];
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var dest, ext, fileName, src;
      if (!config.minify.css.splitMinFile) {
        return promiseHelp.get();
      }
      ext = '.css';
      dest = config.dist.app.client.styles.dir;
      fileName = path.basename(config.fileName.styles.min, ext);
      src = path.join(dest, "{" + fileName + ext + "," + fileName + ".*" + ext + "}");
      return runTask(src, dest, ext);
    }
  };
  return api.runTask();
};
