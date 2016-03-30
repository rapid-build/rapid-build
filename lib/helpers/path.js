var hasProp = {}.hasOwnProperty;

module.exports = {
  isWin: function(path) {
    return path.indexOf('\\') !== -1;
  },
  isWinAbs: function(path) {
    return path.indexOf(':\\') !== -1;
  },
  removeDrive: function(path) {
    var i;
    if (!this.isWinAbs(path)) {
      return path;
    }
    i = path.indexOf(':\\') + 1;
    return path = path.substr(i);
  },
  swapBackslashes: function(path) {
    var regx;
    regx = /\\/g;
    return path.replace(regx, '/');
  },
  formats: function(paths) {
    var _paths, j, len, path;
    _paths = [];
    if (!Array.isArray(paths)) {
      return _paths;
    }
    if (!paths.length) {
      return _paths;
    }
    for (j = 0, len = paths.length; j < len; j++) {
      path = paths[j];
      _paths.push(this.format(path));
    }
    return _paths;
  },
  format: function(path) {
    if (!this.isWin(path)) {
      return path;
    }
    path = this.swapBackslashes(path);
    return path;
  },
  hasTrailingSlash: function(path) {
    return path[path.length - 1] === '/';
  },
  removeLocPartial: function(locPaths, partial) {
    var k, paths, v;
    paths = {};
    partial = this.format(partial);
    for (k in locPaths) {
      if (!hasProp.call(locPaths, k)) continue;
      v = locPaths[k];
      paths[k] = [];
      v.forEach(function(path, i) {
        return paths[k].push(v[i].replace(partial, ''));
      });
    }
    return paths;
  },
  makeRelative: function(path) {
    if (path[0] !== '/') {
      return path;
    }
    return path.substr(1);
  }
};
