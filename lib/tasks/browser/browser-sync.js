module.exports = {
  bs: {},
  bsConfig: {},
  init: function(config) {
    var promiseHelp;
    promiseHelp = require(config.req.helpers + "/promise");
    if (!config.browser.reload) {
      return promiseHelp.get();
    }
    if (!config.build.server) {
      return promiseHelp.get();
    }
    if (config.exclude["default"].server.files) {
      return promiseHelp.get();
    }
    return this.set().setBsConfig(config)._initBs();
  },
  isRunning: function() {
    return !!this.bs.active;
  },
  restart: function() {
    if (!this.isRunning()) {
      return this;
    }
    this.bs.reload({
      stream: false
    });
    return this;
  },
  delayedRestart: function() {
    if (!this.isRunning()) {
      return this;
    }
    setTimeout((function(_this) {
      return function() {
        return _this.restart();
      };
    })(this), 1000);
    return this;
  },
  _initBs: function() {
    var defer, q;
    q = require('q');
    defer = q.defer();
    this.bs.init(this.bsConfig, function() {
      return defer.resolve();
    });
    return defer.promise;
  },
  set: function() {
    this.bs = require('browser-sync').create();
    return this;
  },
  setBsConfig: function(config) {
    this.bsConfig = {
      files: config.glob.browserSync,
      proxy: "http://localhost:" + config.ports.server + "/",
      port: config.ports.reload,
      ui: {
        port: config.ports.reloadUI
      },
      browser: 'google chrome',
      open: config.browser.open
    };
    return this;
  },
  get: function() {
    return this.bs;
  },
  getBsConfig: function() {
    return this.bsConfig;
  }
};
