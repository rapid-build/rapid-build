module.exports = function() {
  var defer, port, q, server;
  q = require('q');
  server = require('./server').server;
  port = server.address().port;
  defer = q.defer();
  server.close(function() {
    console.log("Server stopped on port " + port);
    return defer.resolve();
  });
  return defer.promise;
};
