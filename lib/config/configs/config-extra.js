module.exports = function(config, options) {
  var extra, log, path, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  extra = {};
  config.extra = extra;
  test.log('true', config.extra, 'add extra to config');
  return config;
};
