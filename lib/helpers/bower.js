var hasProp = {}.hasOwnProperty;

module.exports = function(config) {
  var del, fileHelp, fs, fse, helper, isType, log, me, path, pathHelp;
  fs = require('fs');
  fse = require('fs-extra');
  path = require('path');
  del = require('del');
  log = require(config.req.helpers + "/log");
  isType = require(config.req.helpers + "/isType");
  pathHelp = require(config.req.helpers + "/path");
  fileHelp = require(config.req.helpers + "/file")(config);
  helper = {
    getPath: function(pkgName, file, loc) {
      if (loc == null) {
        loc = 'rb';
      }
      return path.join(config.src[loc].client.bower.dir, pkgName, file);
    },
    getDevFile: function(file) {
      if (file.indexOf('/') === 0) {
        return file.substr(1);
      }
      if (file.indexOf('./') === 0) {
        return file.substr(2);
      }
      return file;
    },
    getProdFile: function(file) {
      var base, dir, ext, minFile;
      dir = path.dirname(file);
      if (dir === '.') {
        dir = '';
      }
      ext = path.extname(file);
      base = path.basename(file, ext);
      minFile = path.join(dir, base + ".min" + ext);
      return minFile;
    },
    getDevFileInfo: function(pkgName, files, loc) {
      var _files;
      if (loc == null) {
        loc = 'rb';
      }
      _files = [];
      if (isType.string(files)) {
        files = [files];
      }
      files.forEach((function(_this) {
        return function(file) {
          var _file, _path;
          _file = _this.getDevFile(file);
          _path = _this.getPath(pkgName, _file, loc);
          return _files.push({
            file: _file,
            path: _path
          });
        };
      })(this));
      return _files;
    },
    getProdFileInfo: function(pkgName, files, loc) {
      var _files;
      if (loc == null) {
        loc = 'rb';
      }
      _files = [];
      files.forEach((function(_this) {
        return function(file) {
          var _file, _path;
          _file = _this.getProdFile(file.file);
          _path = _this.getPath(pkgName, _file, loc);
          if (!fileHelp.exists(_path)) {
            return _files.push(file);
          } else {
            return _files.push({
              file: _file,
              path: _path
            });
          }
        };
      })(this));
      return _files;
    },
    getPkgDeps: function(deps) {
      if (!deps) {
        return null;
      }
      if (!isType.object(deps)) {
        return null;
      }
      if (!Object.keys(deps).length) {
        return null;
      }
      return deps;
    },
    getPkg: function(pkg, loc) {
      var devFileInfo, pkgDeps, prodFileInfo;
      if (loc == null) {
        loc = 'rb';
      }
      devFileInfo = this.getDevFileInfo(pkg.name, pkg.main, loc);
      prodFileInfo = this.getProdFileInfo(pkg.name, devFileInfo, loc);
      pkgDeps = this.getPkgDeps(pkg.dependencies);
      return {
        name: pkg.name,
        version: pkg.version,
        dev: devFileInfo,
        prod: prodFileInfo,
        deps: pkgDeps
      };
    },
    getSubPkgs: function(pkgs) {
      var allPkgs, appPkgs, i, name, pkg, rbPkgs, ref, subPkgs, version;
      if (!pkgs.length) {
        return null;
      }
      rbPkgs = me.has.bower('rb') ? me.get.pkgs.from.appOrRb('rb') : {};
      appPkgs = me.has.bower('app') ? me.get.pkgs.from.appOrRb('app') : {};
      allPkgs = Object.keys(rbPkgs).concat(Object.keys(appPkgs));
      if (!allPkgs.length) {
        return null;
      }
      subPkgs = {};
      for (i in pkgs) {
        if (!hasProp.call(pkgs, i)) continue;
        pkg = pkgs[i];
        if (!pkg.deps) {
          continue;
        }
        ref = pkg.deps;
        for (name in ref) {
          if (!hasProp.call(ref, name)) continue;
          version = ref[name];
          if (allPkgs.indexOf(name) !== -1) {
            continue;
          }
          subPkgs[name] = version;
        }
      }
      if (!Object.keys(subPkgs).length) {
        return null;
      }
      return subPkgs;
    },
    getInstalledPkgs: function(pkgsObj, loc) {
      var _pkg, pkg, pkgs, version;
      pkgs = [];
      for (pkg in pkgsObj) {
        if (!hasProp.call(pkgsObj, pkg)) continue;
        version = pkgsObj[pkg];
        _pkg = me.get.installed.pkg(pkg, loc);
        if (_pkg) {
          pkgs.push(_pkg);
        }
      }
      return pkgs;
    },
    depsHaveChanged: function(bowerJson, storedJson) {
      var bDeps, bDepsTot, changed, pkg, sDeps, sDepsTot, version;
      changed = false;
      bDeps = bowerJson.dependencies;
      sDeps = storedJson.dependencies;
      bDepsTot = Object.keys(bDeps).length;
      sDepsTot = Object.keys(sDeps).length;
      if (bDepsTot !== sDepsTot) {
        return true;
      }
      for (pkg in bDeps) {
        if (!hasProp.call(bDeps, pkg)) continue;
        version = bDeps[pkg];
        if (!sDeps[pkg] || sDeps[pkg] !== version) {
          changed = true;
          break;
        }
      }
      return changed;
    },
    forceInstall: function(loc) {
      var _path, bowerJson, dir, force, storedJson;
      if (loc == null) {
        loc = 'rb';
      }
      force = false;
      bowerJson = me.get.json.from.appOrRb(loc);
      dir = config.src[loc].client.bower.dir;
      _path = path.join(dir, '.bower');
      if (!fileHelp.exists(_path)) {
        force = true;
      } else {
        storedJson = fileHelp.read.json(_path);
        if (bowerJson.version !== storedJson.version) {
          force = true;
        } else if (this.depsHaveChanged(bowerJson, storedJson)) {
          force = true;
        }
        if (force) {
          del.sync(dir, {
            force: true
          });
          console.log((loc + " bower_components directory cleaned").yellow);
        }
      }
      fse.mkdirsSync(dir);
      if (force) {
        fileHelp.write.json(_path, bowerJson);
      }
      return force;
    },
    _removeRbAngularMocks: function(paths) {
      var index, k, key, ref, results, v;
      key = 'angular-mocks';
      if (paths.absolute.length) {
        index = null;
        paths.absolute.forEach(function(_path, i) {
          if (_path.indexOf(key) !== -1) {
            return index = i;
          }
        });
        if (index === null) {
          return;
        }
        paths.absolute.splice(index, 1);
        ref = paths.relative;
        results = [];
        for (k in ref) {
          if (!hasProp.call(ref, k)) continue;
          v = ref[k];
          if (v.indexOf(key) !== -1) {
            delete paths.relative[k];
            break;
          } else {
            results.push(void 0);
          }
        }
        return results;
      }
    },
    removeRbAngularMocks: function(loc, paths) {
      if (loc !== 'rb') {
        return;
      }
      if (config.env.is.prod) {
        if (!config.angular.httpBackend.prod) {
          return this._removeRbAngularMocks(paths);
        }
      } else if (!config.angular.httpBackend.dev) {
        return this._removeRbAngularMocks(paths);
      }
    }
  };
  return me = {
    has: {
      bower: function(loc) {
        if (loc == null) {
          loc = 'rb';
        }
        return fileHelp.exists(config.bower[loc].path);
      },
      installed: {
        pkg: function(pkg, loc) {
          var _path;
          if (loc == null) {
            loc = 'rb';
          }
          _path = path.join(config.src[loc].client.bower.dir, pkg, config.bower[loc].file);
          return fileHelp.exists(_path);
        }
      }
    },
    get: {
      json: {
        from: {
          appOrRb: function(loc) {
            if (loc == null) {
              loc = 'rb';
            }
            return require(config.bower[loc].path);
          },
          pkg: function(pkg, loc) {
            if (loc == null) {
              loc = 'rb';
            }
            if (!me.has.installed.pkg(pkg, loc)) {
              return;
            }
            return require(path.join(config.src[loc].client.bower.dir, pkg, config.bower[loc].file));
          }
        }
      },
      pkgs: {
        from: {
          appOrRb: function(loc) {
            var mainDeps;
            if (loc == null) {
              loc = 'rb';
            }
            mainDeps = me.get.json.from.appOrRb(loc).dependencies;
            return mainDeps;
          }
        },
        to: {
          install: function(loc, force) {
            var _pkg, missing, pkg, pkgs, pkgsObj, version;
            if (loc == null) {
              loc = 'rb';
            }
            if (force == null) {
              force = false;
            }
            if (!me.has.bower(loc)) {
              return;
            }
            if (!force) {
              force = helper.forceInstall(loc);
            }
            pkgs = [];
            pkgsObj = me.get.pkgs.from.appOrRb(loc);
            if (force) {
              for (pkg in pkgsObj) {
                if (!hasProp.call(pkgsObj, pkg)) continue;
                version = pkgsObj[pkg];
                pkgs.push(pkg + "#" + version);
              }
            } else {
              missing = me.get.missing.pkgs(loc);
              for (pkg in pkgsObj) {
                if (!hasProp.call(pkgsObj, pkg)) continue;
                version = pkgsObj[pkg];
                _pkg = pkg + "#" + version;
                if (missing.indexOf(_pkg) === -1) {
                  continue;
                }
                pkgs.push(_pkg);
              }
            }
            return pkgs;
          }
        }
      },
      installed: {
        pkg: function(pkg, loc) {
          if (loc == null) {
            loc = 'rb';
          }
          pkg = me.get.json.from.pkg(pkg, loc);
          if (!pkg) {
            return;
          }
          return helper.getPkg(pkg, loc);
        },
        pkgs: function(loc) {
          var pkgs, pkgsObj, subPkgs, subPkgsObj;
          if (loc == null) {
            loc = 'rb';
          }
          pkgs = [];
          pkgsObj = me.get.pkgs.from.appOrRb(loc);
          if (pkgsObj) {
            pkgs = helper.getInstalledPkgs(pkgsObj, loc);
          }
          if (pkgs.length) {
            subPkgs = [];
            subPkgsObj = helper.getSubPkgs(pkgs);
            if (subPkgsObj) {
              subPkgs = helper.getInstalledPkgs(subPkgsObj, loc);
            }
            if (subPkgs.length) {
              pkgs = pkgs.concat(subPkgs);
            }
          }
          return pkgs;
        }
      },
      missing: {
        pkgs: function(loc) {
          var iPkgs, jPkgs, missing, pkg, pkgs, version;
          if (loc == null) {
            loc = 'rb';
          }
          pkgs = [];
          jPkgs = me.get.pkgs.from.appOrRb(loc);
          iPkgs = me.get.installed.pkgs(loc);
          for (pkg in jPkgs) {
            if (!hasProp.call(jPkgs, pkg)) continue;
            version = jPkgs[pkg];
            missing = true;
            iPkgs.forEach(function(v) {
              if (v.name === pkg) {
                return missing = false;
              }
            });
            if (missing) {
              pkgs.push(pkg + "#" + version);
            }
          }
          return pkgs;
        }
      },
      src: function(loc, opts) {
        var absPaths, env, paths, pkgs, relPaths;
        if (loc == null) {
          loc = 'rb';
        }
        if (opts == null) {
          opts = {};
        }
        if (!me.has.bower(loc)) {
          return;
        }
        env = opts.env;
        if (!env && config.env.is.prod) {
          env = 'prod';
        }
        if (['dev', 'prod'].indexOf(env) === -1) {
          env = 'dev';
        }
        absPaths = [];
        relPaths = {};
        if (opts.pkg) {
          pkgs = [me.get.installed.pkg(opts.pkg, loc)];
        } else {
          pkgs = me.get.installed.pkgs(loc);
        }
        pkgs.forEach(function(pkg) {
          return pkg[env].forEach(function(file) {
            var hasPath, name;
            hasPath = pathHelp.format(file.file).indexOf('/') !== -1;
            name = hasPath ? pkg.name : '';
            relPaths[file.path] = path.join(name, file.file);
            return absPaths.push(file.path);
          });
        });
        paths = {
          absolute: absPaths,
          relative: relPaths
        };
        if (!opts.test) {
          helper.removeRbAngularMocks(loc, paths);
        }
        return {
          paths: paths
        };
      }
    }
  };
};
