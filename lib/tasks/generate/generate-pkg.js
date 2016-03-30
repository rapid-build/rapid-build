module.exports = function(config) {
  var _api, api, createJson, del, delDir, fse, path, q;
  q = require('q');
  del = require('del');
  path = require('path');
  fse = require('fs-extra');
  delDir = function(_path, dir) {
    var defer;
    defer = q.defer();
    del(_path, {
      force: true
    }).then(function(paths) {
      var dirMsg;
      dirMsg = 'generated';
      if (dir) {
        dirMsg += " " + dir;
      }
      console.log(("cleaned " + dirMsg + " directory").yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  createJson = function(_path) {
    var defer, format;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    fse.writeJson(_path, {}, format, function(e) {
      var dir, file;
      dir = config.generated.pkg.dir;
      file = path.basename(_path);
      return defer.resolve();
    });
    return defer.promise;
  };
  _api = {
    "delete": {
      pkgs: function() {
        var _path, paths;
        _path = config.generated.path;
        paths = [path.join(_path, '*'), '!' + path.join(_path, '.gitkeep')];
        return delDir(paths);
      },
      pkg: function() {
        return delDir(config.generated.pkg.path, config.generated.pkg.dir);
      }
    },
    clean: {
      pkg: function() {
        var bower, client, files, paths, root, server;
        root = path.join(config.generated.pkg.path, '*.*');
        files = config.generated.pkg.files.path;
        server = path.join(config.src.rb.server.dir);
        client = path.join(config.src.rb.client.dir, '*');
        bower = "!" + config.src.rb.client.bower.dir;
        paths = [root, files, server, client, bower];
        return delDir(paths, config.generated.pkg.dir);
      }
    },
    create: {
      dirs: function() {
        var _path, defer;
        defer = q.defer();
        _path = config.generated.pkg.files.path;
        fse.mkdirs(_path, function(e) {
          var dir;
          dir = config.generated.pkg.dir;
          console.log(("generated " + dir + " directory").yellow);
          return defer.resolve();
        });
        return defer.promise;
      },
      jsonFiles: function() {
        var files, pkg;
        pkg = config.generated.pkg;
        files = pkg.files;
        return q.all([createJson(pkg.config), createJson(pkg.bower), createJson(files.files), createJson(files.testFiles), createJson(files.prodFiles), createJson(files.prodFilesBlueprint)]);
      }
    },
    copy: {
      src: function() {
        var defer, dest, opts, src;
        defer = q.defer();
        src = path.join(config.rb.dir, 'src');
        dest = config.generated.pkg.src.path;
        opts = {
          clobber: true,
          filter: function(s) {
            return !/\.gitkeep$/ig.test(s);
          }
        };
        fse.copy(src, dest, opts, function(e) {
          var dir;
          dir = config.generated.pkg.dir;
          return defer.resolve();
        });
        return defer.promise;
      }
    }
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return _api.clean.pkg();
        }, function() {
          return _api.create.dirs();
        }, function() {
          return _api.create.jsonFiles();
        }, function() {
          return _api.copy.src();
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
