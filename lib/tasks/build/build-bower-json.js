module.exports = function(config, gulp) {
  var api, fse, getData, q;
  q = require('q');
  fse = require('fs-extra');
  getData = function() {
    var dependencies, name, version;
    version = '0.0.0';
    name = config.rb.name;
    dependencies = config.angular.bowerDeps;
    return {
      name: name,
      version: version,
      dependencies: dependencies
    };
  };
  api = {
    runTask: function(src, dest, file) {
      var defer, format, json, jsonFile;
      defer = q.defer();
      format = {
        spaces: '\t'
      };
      json = getData();
      jsonFile = config.generated.pkg.bower;
      fse.writeJson(jsonFile, json, format, function(e) {
        console.log('built bower.json'.yellow);
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
