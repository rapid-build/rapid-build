module.exports = function(server, config) {
  server.app.use(server.express["static"](server.paths.client));
  return server.app.use(server.middleware.bodyParser.json());
};
