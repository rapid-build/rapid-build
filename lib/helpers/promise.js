module.exports = {
  get: function(defer) {
    if (!defer) {
      defer = require('q').defer();
    }
    defer.resolve();
    return defer.promise;
  }
};
