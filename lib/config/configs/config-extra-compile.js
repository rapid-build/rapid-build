module.exports = function(config, options) {
  var compile, formatCompilePaths, log, path, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  compile = {
    rb: {
      client: {
        coffee: [],
        es6: [],
        less: [],
        sass: []
      },
      server: {
        less: [],
        sass: []
      }
    },
    app: {
      client: {
        coffee: options.extra.compile.client.coffee || [],
        es6: options.extra.compile.client.es6 || [],
        less: options.extra.compile.client.less || [],
        sass: options.extra.compile.client.sass || []
      },
      server: {
        less: options.extra.compile.server.less || [],
        sass: options.extra.compile.server.sass || []
      }
    }
  };
  formatCompilePaths = function(appOrRb) {
    var file, files, i, j, lang, len, loc, ref, results;
    ref = ['client', 'server'];
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      loc = ref[j];
      results.push((function() {
        var k, len1, ref1, results1;
        ref1 = ['coffee', 'es6', 'less', 'sass'];
        results1 = [];
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          lang = ref1[k];
          files = compile[appOrRb][loc][lang];
          if (!files) {
            continue;
          }
          if (!files.length) {
            continue;
          }
          results1.push((function() {
            var l, len2, results2;
            results2 = [];
            for (i = l = 0, len2 = files.length; l < len2; i = ++l) {
              file = files[i];
              results2.push(files[i] = path.join(config.src[appOrRb][loc].dir, files[i]));
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };
  formatCompilePaths('rb');
  formatCompilePaths('app');
  config.extra.compile = compile;
  test.log('true', config.extra.compile, 'add extra.compile to config');
  return config;
};
