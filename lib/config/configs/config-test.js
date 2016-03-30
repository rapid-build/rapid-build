module.exports = function(config, options) {
  var _test, getBrowsers, getTestFiles, log, test;
  log = require(config.req.helpers + "/log");
  _test = require(config.req.helpers + "/test")();
  test = {
    client: {},
    dist: {}
  };
  getBrowsers = function() {
    var browser, browserOpts, browsers, i, j, len, len1, match, userBrowser, userBrowsers;
    browsers = ['PhantomJS'];
    browserOpts = ['Chrome', 'Firefox', 'IE', 'Safari'];
    userBrowsers = options.test.client.browsers;
    if (!userBrowsers) {
      return browsers;
    }
    if (!userBrowsers.length) {
      return browsers;
    }
    userBrowsers = userBrowsers.map(function(string) {
      return string.trim().toLowerCase();
    });
    for (i = 0, len = userBrowsers.length; i < len; i++) {
      userBrowser = userBrowsers[i];
      match = null;
      for (j = 0, len1 = browserOpts.length; j < len1; j++) {
        browser = browserOpts[j];
        if (browser.toLowerCase() === userBrowser) {
          match = browser;
          break;
        }
      }
      if (!match) {
        continue;
      }
      browsers.push(match);
    }
    return browsers;
  };
  test.client.browsers = getBrowsers();
  getTestFiles = function(loc) {
    var appOrRb, i, len, ref, structure;
    structure = {};
    ref = ['rb', 'app'];
    for (i = 0, len = ref.length; i < len; i++) {
      appOrRb = ref[i];
      structure[appOrRb] = {
        client: {
          scripts: config.glob[loc][appOrRb].client.test.js,
          styles: config.glob[loc][appOrRb].client.test.css
        },
        server: {
          scripts: config.glob[loc][appOrRb].server.test.js
        }
      };
    }
    return structure;
  };
  test.dist = getTestFiles('dist');
  config.test = test;
  _test.log('true', config.test, 'add test to config');
  return config;
};
