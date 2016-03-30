var hasProp = {}.hasOwnProperty;

module.exports = function(config, gulp) {
  var filter, fs, getDirsRecursively, log, path, q;
  q = require('q');
  fs = require('fs');
  path = require('path');
  log = require(config.req.helpers + "/log");
  getDirsRecursively = function(_path, _dirs) {
    var e, error, filePath, filenames, j, len, newPath;
    if (_dirs == null) {
      _dirs = [];
    }
    try {
      filenames = fs.readdirSync(_path);
    } catch (error) {
      e = error;
      console.log(e.message.error);
      return _dirs;
    }
    if (!filenames.length) {
      return _dirs;
    }
    for (j = 0, len = filenames.length; j < len; j++) {
      filePath = filenames[j];
      newPath = path.join(_path, filePath);
      if (!fs.statSync(newPath).isDirectory()) {
        continue;
      }
      _dirs.push(newPath);
      getDirsRecursively(newPath, _dirs);
    }
    return _dirs;
  };
  filter = function(dirs, filterPaths) {
    var _dirs, _path, fPath, flag, j, l, len, len1;
    _dirs = [];
    for (j = 0, len = dirs.length; j < len; j++) {
      _path = dirs[j];
      flag = false;
      for (l = 0, len1 = filterPaths.length; l < len1; l++) {
        fPath = filterPaths[l];
        if (_path.indexOf(fPath) !== -1) {
          flag = true;
          break;
        }
      }
      if (!flag) {
        _dirs.push(_path);
      }
    }
    return _dirs;
  };
  return {
    filter: {
      dirs: filter
    },
    get: {
      dirs: function(initPath, filterPaths, reverse) {
        var dirs;
        if (filterPaths == null) {
          filterPaths = [];
        }
        dirs = getDirsRecursively(initPath);
        if (filterPaths.length) {
          dirs = filter(dirs, filterPaths);
        }
        if (reverse === 'reverse') {
          dirs.reverse();
        }
        return dirs;
      },
      emptyDirs: function(initPath, filterPaths, reverse) {
        var _dirs, _path, dirs, fileDirs, filePath, filenames, flag, i, j, k, l, len, len1, len2, m, newPath, v;
        if (filterPaths == null) {
          filterPaths = [];
        }
        dirs = this.dirs(initPath, filterPaths, reverse);
        if (!dirs.length) {
          return dirs;
        }
        _dirs = [];
        fileDirs = {};
        for (j = 0, len = dirs.length; j < len; j++) {
          _path = dirs[j];
          filenames = fs.readdirSync(_path);
          for (i = l = 0, len1 = filenames.length; l < len1; i = ++l) {
            filePath = filenames[i];
            newPath = path.join(_path, filePath);
            if (!fs.statSync(newPath).isFile()) {
              continue;
            }
            fileDirs[_path] = i + 1;
          }
        }
        if (!Object.keys(fileDirs).length) {
          return dirs;
        }
        for (m = 0, len2 = dirs.length; m < len2; m++) {
          _path = dirs[m];
          flag = false;
          for (k in fileDirs) {
            if (!hasProp.call(fileDirs, k)) continue;
            v = fileDirs[k];
            if (k.indexOf(_path) !== -1) {
              flag = true;
              break;
            }
          }
          if (!flag) {
            _dirs.push(_path);
          }
        }
        return _dirs;
      }
    },
    hasFiles: function(src) {
      var defer, hasFiles, opts;
      defer = q.defer();
      opts = {
        buffer: false,
        read: false
      };
      hasFiles = false;
      gulp.src(src, opts).on('data', function(file) {
        if (!file) {
          return;
        }
        hasFiles = true;
        return this.end();
      }).on('end', function() {
        return defer.resolve(hasFiles);
      });
      return defer.promise;
    }
  };
};
