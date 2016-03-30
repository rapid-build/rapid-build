var hasProp = {}.hasOwnProperty;

module.exports = function(config, gulp) {
  var Less, cmtsRegex, importRegX, log, path, pathHelp, q;
  q = require('q');
  path = require('path');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  cmtsRegex = /\/\/.*|\/\*\s*?.*?\s*?\*\//g;
  importRegX = /@import\s*?(?!\s*?\(css\)*?).*?['"]+?(.*?)['"]/g;
  return Less = (function() {
    var addNotToImports, findImports, getImports, isImport;

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
      return imports.indexOf(_path) !== -1;
    };

    findImports = function(file) {
      var _path, contents, dir, impDir, imports, lessExt, match, matches;
      contents = file.contents;
      if (!contents) {
        return [];
      }
      contents = contents.toString();
      dir = path.dirname(file.path);
      lessExt = '.less';
      imports = [];
      contents = contents.replace(cmtsRegex, '');
      while ((matches = importRegX.exec(contents)) !== null) {
        match = matches[1];
        if (match.indexOf('//') !== -1) {
          continue;
        }
        _path = path.resolve(dir, match);
        impDir = path.extname(_path);
        if (!impDir) {
          _path += lessExt;
        }
        _path = pathHelp.format(_path);
        imports.push(_path);
      }
      return imports;
    };

    function Less(src1) {
      this.src = src1;
      this.imports = {};
      this.files = {};
    }

    Less.prototype.addImport = function(file) {
      var paths;
      paths = findImports(file);
      if (!paths.length) {
        return this;
      }
      this.files[file.path] = paths;
      return this;
    };

    Less.prototype.setImports = function() {
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

    Less.prototype.getFiles = function() {
      return this.files;
    };

    Less.prototype.getImports = function() {
      var files, imports;
      files = this.getFiles();
      imports = getImports(files);
      this.imports = addNotToImports(imports);
      return this.imports;
    };

    Less.prototype.getWatchSrc = function(_path) {
      var files, imports, k1, src, v1;
      _path = pathHelp.format(_path);
      files = this.getFiles();
      imports = getImports(files);
      if (!isImport(imports, _path)) {
        return [_path];
      }
      src = [];
      for (k1 in files) {
        if (!hasProp.call(files, k1)) continue;
        v1 = files[k1];
        if (isImport(imports, k1)) {
          continue;
        }
        if (v1.indexOf(_path) === -1) {
          continue;
        }
        src.push(k1);
      }
      return src;
    };

    return Less;

  })();
};
