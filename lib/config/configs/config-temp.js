var hasProp = {}.hasOwnProperty;

module.exports = function(config) {
  var addTypes, addTypesRbAndApp, glob, log, path, rbAndApp, tDir, temp, test, types;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  tDir = '.temp';
  glob = '/**/*';
  types = ['scripts', 'styles'];
  rbAndApp = ['rb', 'app'];
  temp = {};
  temp.client = {};
  temp.client.dir = path.join(config.dist.app.client.dir, tDir);
  temp.client.glob = path.join(temp.client.dir, glob);
  addTypes = function() {
    var k1, k2, ref, results, v1, v2;
    ref = config.fileName;
    results = [];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      if (types.indexOf(k1) === -1) {
        continue;
      }
      temp.client[k1] = {};
      temp.client[k1].dir = path.join(temp.client.dir, config.dist.app.client[k1].dirName);
      temp.client[k1].glob = path.join(temp.client[k1].dir, glob);
      results.push((function() {
        var results1;
        results1 = [];
        for (k2 in v1) {
          if (!hasProp.call(v1, k2)) continue;
          v2 = v1[k2];
          if (k2 !== 'min') {
            continue;
          }
          temp.client[k1][k2] = {};
          temp.client[k1][k2].file = v2;
          results1.push(temp.client[k1][k2].path = path.join(temp.client[k1].dir, temp.client[k1][k2].file));
        }
        return results1;
      })());
    }
    return results;
  };
  addTypesRbAndApp = function() {
    var k1, ref, results, v1;
    ref = config.fileName;
    results = [];
    for (k1 in ref) {
      if (!hasProp.call(ref, k1)) continue;
      v1 = ref[k1];
      if (types.indexOf(k1) === -1) {
        continue;
      }
      results.push(rbAndApp.forEach(function(appOrRb) {
        var typeDir;
        typeDir = temp.client[k1].dir;
        temp.client[k1][appOrRb] = {};
        return temp.client[k1][appOrRb].dir = path.join(typeDir, appOrRb);
      }));
    }
    return results;
  };
  addTypes();
  addTypesRbAndApp();
  config.temp = temp;
  test.log('true', config.temp, 'add temp to config');
  return config;
};
