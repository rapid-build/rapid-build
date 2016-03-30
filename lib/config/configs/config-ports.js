module.exports = function(config, options) {
  var log, ports, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  ports = {};
  ports.server = options.ports.server || 3000;
  ports.reload = options.ports.reload || 3001;
  ports.reloadUI = options.ports.reloadUI || 3002;
  ports.test = options.ports.test || 9876;
  config.ports = ports;
  test.log('true', config.ports, 'add ports to config');
  return config;
};
