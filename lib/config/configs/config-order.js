var hasProp = {}.hasOwnProperty;

module.exports = function(config, options) {
  var angularFiles, files, getAngularFiles, getDirName, log, order, path, pathHelp, rb, removeExts, removeRbAngularMocks, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  test = require(config.req.helpers + "/test")();
  angularFiles = ['angular.js', 'angular-mocks.js', 'angular-resource.js', 'angular-route.js', 'angular-sanitize.js'];
  getDirName = function(appOrRb, type) {
    var dir, i;
    dir = pathHelp.format(config.dist[appOrRb].client[type].dir);
    i = dir.lastIndexOf('/') + 1;
    return dir.substr(i);
  };
  getAngularFiles = function() {
    var _paths;
    _paths = [];
    angularFiles.forEach(function(file, i) {
      return _paths.push(rb.bower + "/" + file);
    });
    return _paths;
  };
  rb = {
    bower: config.dist.rb.client.bower.dirName,
    libs: config.dist.rb.client.libs.dirName,
    scripts: getDirName('rb', 'scripts'),
    styles: getDirName('rb', 'styles')
  };
  rb.files = {
    rb: [rb.scripts + "/app.js"],
    angular: getAngularFiles()
  };
  order = {
    rb: {
      scripts: {
        first: [],
        last: []
      },
      styles: {
        first: [],
        last: []
      }
    },
    app: {
      scripts: {
        first: options.order.scripts.first || [],
        last: options.order.scripts.last || []
      },
      styles: {
        first: options.order.styles.first || [],
        last: options.order.styles.last || []
      }
    }
  };
  files = [];
  if (!config.exclude.angular.files) {
    files = files.concat(rb.files.angular);
  }
  order.rb.scripts.first = files.concat(rb.files.rb);
  removeRbAngularMocks = function() {
    return order.rb.scripts.first.splice(1, 1);
  };
  order.removeRbAngularMocks = function() {
    if (config.env.is.prod) {
      if (!config.angular.httpBackend.prod) {
        return removeRbAngularMocks();
      }
    } else if (!config.angular.httpBackend.dev) {
      return removeRbAngularMocks();
    }
  };
  removeExts = function() {
    var k1, k2, k3, results, v1, v2, v3;
    results = [];
    for (k1 in order) {
      if (!hasProp.call(order, k1)) continue;
      v1 = order[k1];
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          results1.push((function() {
            var results2;
            results2 = [];
            for (k3 in v2) {
              if (!hasProp.call(v2, k3)) continue;
              v3 = v2[k3];
              if (!v3.length) {
                continue;
              }
              results2.push(v3.forEach(function(v4, i) {
                var ext;
                ext = path.extname(v4);
                if (ext !== '.min') {
                  return v3[i] = v3[i].replace(ext, '');
                }
              }));
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };
  removeExts();
  config.order = order;
  test.log('true', config.order, 'add order to config');
  return config;
};
