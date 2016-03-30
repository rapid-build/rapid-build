module.exports = function(config) {
  var fse, promiseHelp, q;
  q = require('q');
  fse = require('fs-extra');
  promiseHelp = require(config.req.helpers + "/promise");
  return {
    buildFile: function(build, msg) {
      var configFile, defer, format;
      if (build == null) {
        build = true;
      }
      if (msg == null) {
        msg = 'built';
      }
      if (!build) {
        return promiseHelp.get();
      }
      if (msg !== 'built') {
        msg = 'rebuilt';
      }
      defer = q.defer();
      format = {
        spaces: '\t'
      };
      configFile = config.generated.pkg.config;
      fse.writeJson(configFile, config, format, function(e) {
        console.log((msg + " config.json").yellow);
        return defer.resolve();
      });
      return defer.promise;
    }
  };
};
