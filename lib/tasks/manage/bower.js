module.exports = function(config) {
  var api, bower, bowerHelper, promiseHelp, q, runTask;
  q = require('q');
  bower = require('bower');
  promiseHelp = require(config.req.helpers + "/promise");
  bowerHelper = require(config.req.helpers + "/bower")(config);
  runTask = function(appOrRb) {
    var bowerPkgs, defer;
    defer = q.defer();
    bowerPkgs = bowerHelper.get.pkgs.to.install(appOrRb);
    if (!bowerPkgs || !bowerPkgs.length) {
      return promiseHelp.get(defer);
    }
    bower.commands.install(bowerPkgs, {
      force: true
    }, {
      directory: '',
      forceLatest: true,
      cwd: config.src[appOrRb].client.bower.dir
    }).on('log', function(result) {
      return console.log("bower: " + result.id.cyan + " " + result.message.cyan);
    }).on('error', function(e) {
      console.log(e);
      return defer.resolve();
    }).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer;
      defer = q.defer();
      q.all([runTask('rb'), runTask('app')]).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
