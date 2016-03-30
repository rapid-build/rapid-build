module.exports = function(server, config) {
  var spa;
  spa = config.spa.dist.file;
  return server.app.get('*', function(req, res) {
    var msg;
    msg = 'Hello Server!';
    if (!config.build.client) {
      return res.send(msg);
    }
    if (config.exclude.spa) {
      return res.send(msg);
    }
    if (config.env.is.test && !config.env.is.testClient) {
      return res.send(msg);
    }
    return res.sendFile(spa, {
      root: server.paths.client
    });
  });
};
