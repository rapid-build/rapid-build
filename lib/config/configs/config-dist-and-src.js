var hasProp = {}.hasOwnProperty;

module.exports = function(config, options) {
  var addDirName, addToServerAppDist, addToServerRbDist, dir, file, formatConfig, formatDist, getDirs, log, path, updateServerScriptsDir;
  path = require('path');
  log = require(config.req.helpers + "/log");
  dir = {
    dist: 'dist',
    src: 'src',
    client: 'client',
    images: 'images',
    bower: 'bower_components',
    libs: 'libs',
    server: 'server',
    scripts: 'scripts',
    styles: 'styles',
    test: 'test',
    views: 'views'
  };
  file = {
    appServer: 'routes.js',
    rbServerInit: 'init-server.js'
  };
  getDirs = function(loc, isApp) {
    var clientDirName, info, o, serverDirName;
    o = {};
    switch (loc) {
      case 'dist':
        o.dir = options[loc].dir;
        o.clientDir = options[loc].client.dir;
        o.serverDir = options[loc].server.dir;
        break;
      case 'src':
        if (isApp) {
          o.clientDir = options[loc].client.dir;
        }
    }
    if (isApp) {
      o.clientBower = options[loc].client.bower.dir;
      o.clientImages = options[loc].client.images.dir;
      o.clientLibs = options[loc].client.libs.dir;
      o.clientScripts = options[loc].client.scripts.dir;
      o.clientStyles = options[loc].client.styles.dir;
      o.clientTest = options[loc].client.test.dir;
      o.clientViews = options[loc].client.views.dir;
      o.serverTest = options[loc].server.test.dir;
    }
    clientDirName = loc === 'dist' ? o.clientDir || dir.client : null;
    serverDirName = loc === 'dist' ? o.serverDir || dir.server : null;
    info = {
      dir: o.dir || dir[loc],
      client: {
        dir: o.clientDir || dir.client,
        dirName: clientDirName,
        bower: {
          dir: o.clientBower || dir.bower
        },
        images: {
          dir: o.clientImages || dir.images
        },
        libs: {
          dir: o.clientLibs || dir.libs
        },
        scripts: {
          dir: o.clientScripts || dir.scripts
        },
        styles: {
          dir: o.clientStyles || dir.styles
        },
        test: {
          dir: o.clientTest || dir.test
        },
        views: {
          dir: o.clientViews || dir.views
        }
      },
      server: {
        dir: o.serverDir || dir.server,
        dirName: serverDirName,
        scripts: {
          dir: o.serverDir || dir.scripts
        },
        test: {
          dir: o.serverTest || dir.test
        }
      }
    };
    if (loc === 'dist') {
      if (!isApp) {
        info.client.dirName = config.rb.prefix.distDir;
        info.server.dirName = config.rb.prefix.distDir;
      }
    } else {
      delete info.client.dirName;
      delete info.server.dirName;
    }
    return info;
  };
  config.dist = {};
  config.dist.dir = options.dist.dir || dir.dist;
  config.dist.rb = getDirs('dist');
  config.dist.app = getDirs('dist', true);
  config.src = {};
  config.src.rb = getDirs('src');
  config.src.app = getDirs('src', true);
  formatConfig = function(loc, src) {
    var cwd, isDist, isSrc, k1, k2, results, v1, v2;
    cwd = '';
    isSrc = loc === 'src';
    isDist = loc === 'dist';
    if (isSrc) {
      if (src === 'rb') {
        cwd = config.generated.pkg.path;
      }
      if (src === 'app') {
        cwd = config.app.dir;
      }
    }
    loc = config[loc][src];
    results = [];
    for (k1 in loc) {
      if (!hasProp.call(loc, k1)) continue;
      v1 = loc[k1];
      if (k1 === 'dir') {
        loc.dir = path.join(cwd, v1);
        continue;
      }
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          if (k2 === 'dirName') {
            continue;
          }
          if (k2 === 'dir') {
            if (isDist && src === 'rb') {
              results1.push(v1.dir = path.join(loc.dir, v2, config.rb.prefix.distDir));
            } else {
              results1.push(v1.dir = path.join(loc.dir, v2));
            }
          } else {
            results1.push(v1[k2].dir = path.join(v1.dir, v2.dir));
          }
        }
        return results1;
      })());
    }
    return results;
  };
  formatConfig('dist', 'rb');
  formatConfig('dist', 'app');
  formatConfig('src', 'rb');
  formatConfig('src', 'app');
  addDirName = function(loc) {
    var k1, k2, k3, ref, results, v1, v2, v3;
    ref = config[loc];
    results = [];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      if (k1 === 'dir') {
        continue;
      }
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          if (k2 === 'dir') {
            continue;
          }
          results1.push((function() {
            var results2;
            results2 = [];
            for (k3 in v2) {
              if (!hasProp.call(v2, k3)) continue;
              v3 = v2[k3];
              if (k3 === 'dirName') {
                continue;
              }
              if (k3 === 'dir') {
                continue;
              }
              if (k2 === 'server' && k3 !== 'test') {
                continue;
              }
              if (k1 === 'app') {
                results2.push(v3.dirName = options[loc][k2][k3].dir || dir[k3]);
              } else {
                results2.push(v3.dirName = dir[k3]);
              }
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };
  addDirName('dist');
  updateServerScriptsDir = function() {
    return ['dist', 'src'].forEach(function(v1) {
      return ['app', 'rb'].forEach(function(v2) {
        return config[v1][v2].server.scripts.dir = config[v1][v2].server.dir;
      });
    });
  };
  addToServerRbDist = function() {
    config.dist.rb.server.scripts.file = file.rbServerInit;
    config.dist.rb.server.scripts.path = path.join(config.app.dir, config.dist.rb.server.scripts.dir);
    return config.dist.rb.server.scripts.filePath = path.join(config.dist.rb.server.scripts.path, config.dist.rb.server.scripts.file);
  };
  addToServerAppDist = function() {
    config.dist.app.server.scripts.file = options.dist.server.fileName || file.appServer;
    return config.dist.app.server.scripts.path = path.join(config.app.dir, config.dist.app.server.scripts.dir);
  };
  updateServerScriptsDir();
  addToServerRbDist();
  addToServerAppDist();
  formatDist = function() {
    return ['app', 'rb'].forEach(function(v) {
      return delete config.dist[v].dir;
    });
  };
  formatDist();
  return config;
};
