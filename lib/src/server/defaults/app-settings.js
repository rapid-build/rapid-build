module.exports = function(server, config) {
  return server.app.set('x-powered-by', false);
};
