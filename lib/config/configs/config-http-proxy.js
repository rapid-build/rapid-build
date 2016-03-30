module.exports = function(config, options) {
  var httpProxy, log, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  httpProxy = options.httpProxy || [];
  config.httpProxy = httpProxy;
  test.log('true', config.httpProxy, 'add httpProxy to config');
  return config;
};
