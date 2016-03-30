var hasProp = {}.hasOwnProperty;

module.exports = function(config, gulp) {
  var Sass, cmtsRegex, importRegX, log, path, pathHelp, q;
  q = require('q');
  path = require('path');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  cmtsRegex = /\/\/.*|\/\*\s*?.*?\s*?\*\//g;
  importRegX = /@import\s*?(?!\s*?\(css\)*?).*?['"]+?(.*?)['"]/g;
  return Sass = (function() {
    var addNotToImports, fileHasImport, findImports, getExtlessPath, getImports, isImport;

    getImports = function(files) {
      var imports, k1, v1;
      imports = {};
      for (k1 in files) {
        if (!hasProp.call(files, k1)) continue;
        v1 = files[k1];
        if (!v1.length) {
          continue;
        }
        v1.forEach(function(v2, i) {
          return imports[v2] = i;
        });
      }
      return Object.keys(imports);
    };

    addNotToImports = function(imports) {
      imports.forEach(function(v, i) {
        return imports[i] = "!" + v;
      });
      return imports;
    };

    isImport = function(imports, _path) {
      var _import, flag, j, len;
      flag = false;
      if (!imports.length) {
        return flag;
      }
      _path = getExtlessPath(_path);
      for (j = 0, len = imports.length; j < len; j++) {
        _import = imports[j];
        if (_import.indexOf(_path) !== -1) {
          flag = true;
          break;
        }
      }
      return flag;
    };

    fileHasImport = function(imports, _path) {
      return isImport(imports, _path);
    };

    getExtlessPath = function(_path) {
      var lastIndex;
      lastIndex = _path.lastIndexOf('.') + 1;
      return _path = _path.substr(0, lastIndex);
    };

    findImports = function(file) {
      var _path, contents, cssExt, dir, impDir, imports, match, matches, sassExts;
      contents = file.contents;
      if (!contents) {
        return [];
      }
      contents = contents.toString();
      dir = path.dirname(file.path);
      cssExt = '.css';
      sassExts = '.{sass,scss}';
      imports = [];
      contents = contents.replace(cmtsRegex, '');
      while ((matches = importRegX.exec(contents)) !== null) {
        match = matches[1];
        if (match.indexOf('//') !== -1) {
          continue;
        }
        if (matches[0].indexOf('url(') !== -1) {
          continue;
        }
        _path = path.resolve(dir, match);
        impDir = path.extname(_path);
        if (impDir === cssExt) {
          continue;
        }
        if (!impDir) {
          _path += sassExts;
        }
        _path = pathHelp.format(_path);
        imports.push(_path);
      }
      return imports;
    };

    function Sass(src1) {
      this.src = src1;
      this.imports = {};
      this.files = {};
    }

    Sass.prototype.addImport = function(file) {
      var paths;
      paths = findImports(file);
      if (!paths.length) {
        return this;
      }
      this.files[file.path] = paths;
      return this;
    };

    Sass.prototype.setImports = function() {
      var defer;
      defer = q.defer();
      gulp.src(this.src).on('data', (function(_this) {
        return function(file) {
          return _this.addImport(file);
        };
      })(this)).on('end', (function(_this) {
        return function() {
          return defer.resolve(_this);
        };
      })(this));
      return defer.promise;
    };

    Sass.prototype.getFiles = function() {
      return this.files;
    };

    Sass.prototype.getImports = function() {
      var files, imports;
      files = this.getFiles();
      imports = getImports(files);
      this.imports = addNotToImports(imports);
      return this.imports;
    };

    Sass.prototype.getWatchSrc = function(_path) {
      var _file, fileImports, files, imports, src;
      _path = pathHelp.format(_path);
      files = this.getFiles();
      imports = getImports(files);
      if (!isImport(imports, _path)) {
        return [_path];
      }
      src = [];
      for (_file in files) {
        if (!hasProp.call(files, _file)) continue;
        fileImports = files[_file];
        if (isImport(imports, _file)) {
          continue;
        }
        if (!fileHasImport(fileImports, _path)) {
          continue;
        }
        src.push(_file);
      }
      return src;
    };

    return Sass;

  })();
};
