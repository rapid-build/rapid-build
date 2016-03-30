module.exports = function(app, config) {
  var port, server;
  port = process.env.PORT || config.ports.server;
  return server = app.listen(port, function() {
    return console.log("Server started on port " + port);
  });
};
