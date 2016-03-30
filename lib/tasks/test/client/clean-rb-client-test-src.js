module.exports = function(config) {
  var api, cleanTask, del, path, q;
  q = require('q');
  del = require('del');
  path = require('path');
  cleanTask = function(src) {
    var defer;
    defer = q.defer();
    del(src, {
      force: true
    }).then(function(paths) {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var dest, src;
      dest = config.src.rb.client.test.dir;
      src = [path.join(dest, '*'), path.join("!" + dest, '.gitkeep')];
      return cleanTask(src);
    }
  };
  return api.runTask();
};
