var PLUGIN_NAME, PluginError, addConfigImports, findAndReplace, format, gulpAbsoluteCssUrls, gutil, importNoUrlRegX, path, pathHelp, replaceCssUrls, through, urlRegX;

PLUGIN_NAME = 'gulp-absolute-css-urls';

through = require('through2');

gutil = require('gulp-util');

path = require('path');

PluginError = gutil.PluginErrors;

urlRegX = /url\s*\(\s*['"]?(.*?)['"]?\s*\)(?![^\*]*?\*\/)/g;

importNoUrlRegX = /@import\s*?['"]+?(.*?)['"]+?(?![^\*]*?\*\/)/g;

pathHelp = {
  isWin: function(_path) {
    return _path.indexOf('\\') !== -1;
  },
  isWinAbs: function(_path) {
    return _path.indexOf(':\\') !== -1;
  },
  removeDrive: function(_path) {
    var i;
    if (!this.isWinAbs(_path)) {
      return _path;
    }
    i = _path.indexOf(':\\') + 1;
    return _path = _path.substr(i);
  },
  swapBackslashes: function(_path) {
    var regx;
    regx = /\\/g;
    return _path.replace(regx, '/');
  },
  format: function(_path) {
    if (!this.isWin(_path)) {
      return _path;
    }
    _path = this.removeDrive(_path);
    _path = this.swapBackslashes(_path);
    return _path;
  },
  hasTrailingSlash: function(_path) {
    return _path[_path.length - 1] === '/';
  },
  isAbsolute: function(urlPath) {
    return urlPath[0] === '/';
  },
  isExternal: function(urlPath) {
    return urlPath.indexOf('//') !== -1;
  },
  isImport: function(_path) {
    return path.extname(_path) === '.css';
  },
  getRelative: function(paths) {
    var _path;
    _path = path.resolve(paths.abs, paths.url);
    return pathHelp.format(_path);
  },
  getAbsolute: function(paths, opts) {
    var _path, base, prependPath, rel;
    prependPath = opts.prependPath !== false;
    base = paths.base;
    rel = paths.rel;
    base = base.split('/');
    base = base[base.length - 2];
    base = "/" + base;
    rel = rel.split('/');
    rel = rel[0];
    rel = "/" + rel;
    _path = '';
    if (prependPath) {
      _path = "" + base + rel;
    }
    if (paths.isRbPath) {
      _path = "/" + opts.rbDistDir + _path;
    }
    _path = "" + _path + paths.url;
    return _path;
  },
  getCssUrl: function(_path) {
    var url;
    _path = this.format(_path);
    return url = "url('" + _path + "')";
  },
  getCssImport: function(_path) {
    var _import;
    _path = this.format(_path);
    return _import = "@import '" + _path + "'";
  },
  getImport: function(_path, paths) {
    if (!this.isImport(_path)) {
      return;
    }
    return _path = "" + paths.root + _path;
  },
  formatCssUrl: function(match, formatTask, config, paths, opts) {
    var _import, _path, isAbsolute, isExternal, msg, url;
    if (paths == null) {
      paths = {};
    }
    if (opts == null) {
      opts = {};
    }
    isExternal = this.isExternal(paths.url);
    if (isExternal) {
      return {
        url: match
      };
    }
    isAbsolute = this.isAbsolute(paths.url);
    msg = isAbsolute ? 'absolute' : 'relative';
    _path = isAbsolute ? this.getAbsolute(paths, opts) : this.getRelative(paths);
    _import = this.getImport(_path, paths);
    url = pathHelp[formatTask](_path);
    return {
      url: url,
      _import: _import
    };
  }
};

format = {
  root: function(_path) {
    if (!_path) {
      return null;
    }
    _path = _path.trim();
    _path = pathHelp.swapBackslashes(_path);
    if (_path.length > 1 && pathHelp.hasTrailingSlash(_path)) {
      _path = _path.slice(0, -1);
    }
    if (_path.length === 1 && _path[0] === '/') {
      return null;
    }
    if (_path.indexOf('/') === 0) {
      return _path;
    }
    return _path = "/" + _path;
  },
  absPath: function(file, root) {
    var _path;
    _path = file.path.replace(file.cwd, '');
    _path = pathHelp.swapBackslashes(_path);
    _path = _path.replace(root, '');
    return _path = path.dirname(_path);
  }
};

addConfigImports = function(imports, config, paths) {
  var appOrRb, cImports, key;
  appOrRb = paths.isRbPath ? 'rb' : 'app';
  cImports = config.internal[appOrRb].client.css.imports;
  key = "" + paths.root + paths.abs + "/" + paths.rel;
  if (!imports.length) {
    if (cImports[key]) {
      delete cImports[key];
    }
    return;
  }
  return cImports[key] = imports;
};

findAndReplace = function(css, config, paths, opts, imports, formatTask, regX) {
  return css.replace(regX, function(match, urlPath) {
    var _css;
    paths.url = urlPath;
    _css = pathHelp.formatCssUrl(match, formatTask, config, paths, opts);
    if (_css._import) {
      imports.push(_css._import);
    }
    return _css.url;
  });
};

replaceCssUrls = function(file, root, config, opts) {
  var _root, abs, base, css, imports, isRbPath, paths, rel;
  if (opts == null) {
    opts = {};
  }
  css = file.contents.toString();
  _root = format.root(root);
  abs = format.absPath(file, _root);
  base = pathHelp.format(file.base);
  rel = pathHelp.format(file.relative);
  isRbPath = base.indexOf(opts.rbDistDir) !== -1;
  paths = {
    root: root,
    abs: abs,
    base: base,
    rel: rel,
    isRbPath: isRbPath
  };
  imports = [];
  css = findAndReplace(css, config, paths, opts, imports, 'getCssUrl', urlRegX);
  css = findAndReplace(css, config, paths, opts, imports, 'getCssImport', importNoUrlRegX);
  addConfigImports(imports, config, paths);
  return css;
};

gulpAbsoluteCssUrls = function(root, config, opts) {
  return through.obj(function(file, enc, cb) {
    var contents;
    if (file.isNull()) {
      return cb(null, file);
    }
    if (file.isStream()) {
      return cb(new PluginError(PLUGIN_NAME, 'streaming not supported'));
    }
    if (file.isBuffer()) {
      contents = replaceCssUrls(file, root, config, opts);
      file.contents = new Buffer(contents);
    }
    return cb(null, file);
  });
};

module.exports = gulpAbsoluteCssUrls;
