module.exports = function(config, options) {
  var copy, formatCopyPaths, log, path, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  copy = {
    rb: {
      client: [],
      server: []
    },
    app: {
      client: options.extra.copy.client || [],
      server: options.extra.copy.server || []
    }
  };
  formatCopyPaths = function(appOrRb) {
    var file, files, i, j, len, loc, ref, results;
    ref = ['client', 'server'];
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      loc = ref[j];
      files = copy[appOrRb][loc];
      if (!files.length) {
        continue;
      }
      results.push((function() {
        var k, len1, results1;
        results1 = [];
        for (i = k = 0, len1 = files.length; k < len1; i = ++k) {
          file = files[i];
          results1.push(files[i] = path.join(config.src[appOrRb][loc].dir, files[i]));
        }
        return results1;
      })());
    }
    return results;
  };
  formatCopyPaths('rb');
  formatCopyPaths('app');
  config.extra.copy = copy;
  test.log('true', config.extra.copy, 'add extra.copy to config');
  return config;
};
