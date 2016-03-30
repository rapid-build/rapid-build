module.exports = function(config, options) {
  var browser, log, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  browser = {};
  browser.open = options.browser.open === false ? false : true;
  browser.reload = options.browser.reload === false ? false : true;
  config.browser = browser;
  test.log('true', config.browser, 'add browser to config');
  return config;
};
