module.exports = function(config, options) {
  var angularOptions, browserOptions, buildOptions, distAndSrcOptions, excludeOptions, extraCompile, extraCopy, extraOptions, isType, log, minifyOptions, orderOptions, portOptions, proxyOptions, serverDistOptions, serverOptions, spaOptions, testOptions;
  log = require(config.req.helpers + "/log");
  isType = require(config.req.helpers + "/isType");
  buildOptions = function() {
    if (!isType.object(options.build)) {
      options.build = {};
    }
    if (!isType.boolean(options.build.client)) {
      options.build.client = null;
    }
    if (!isType.boolean(options.build.server)) {
      return options.build.server = null;
    }
  };
  distAndSrcOptions = function() {
    return ['dist', 'src'].forEach(function(v1) {
      if (!isType.object(options[v1])) {
        options[v1] = {};
      }
      if (!isType.string(options[v1].dir)) {
        options[v1].dir = null;
      }
      return ['client', 'server'].forEach(function(v2) {
        if (!isType.object(options[v1][v2])) {
          options[v1][v2] = {};
        }
        if (!isType.string(options[v1][v2].dir)) {
          options[v1][v2].dir = null;
        }
        if (v2 === 'server') {
          return ['test'].forEach(function(v3) {
            if (!isType.object(options[v1][v2][v3])) {
              options[v1][v2][v3] = {};
            }
            if (!isType.string(options[v1][v2][v3].dir)) {
              return options[v1][v2][v3].dir = null;
            }
          });
        } else {
          return ['bower', 'images', 'libs', 'scripts', 'styles', 'test', 'views'].forEach(function(v3) {
            if (!isType.object(options[v1][v2][v3])) {
              options[v1][v2][v3] = {};
            }
            if (!isType.string(options[v1][v2][v3].dir)) {
              return options[v1][v2][v3].dir = null;
            }
          });
        }
      });
    });
  };
  portOptions = function() {
    if (!isType.object(options.ports)) {
      options.ports = {};
    }
    if (!isType.number(options.ports.server)) {
      options.ports.server = null;
    }
    if (!isType.number(options.ports.reload)) {
      options.ports.reload = null;
    }
    if (!isType.number(options.ports.reloadUI)) {
      options.ports.reloadUI = null;
    }
    if (!isType.number(options.ports.test)) {
      return options.ports.test = null;
    }
  };
  orderOptions = function() {
    if (!isType.object(options.order)) {
      options.order = {};
    }
    if (!isType.object(options.order.scripts)) {
      options.order.scripts = {};
    }
    if (!isType.object(options.order.styles)) {
      options.order.styles = {};
    }
    if (!isType.array(options.order.scripts.first)) {
      options.order.scripts.first = null;
    }
    if (!isType.array(options.order.scripts.last)) {
      options.order.scripts.last = null;
    }
    if (!isType.array(options.order.styles.first)) {
      options.order.styles.first = null;
    }
    if (!isType.array(options.order.styles.last)) {
      return options.order.styles.last = null;
    }
  };
  angularOptions = function() {
    if (!isType.object(options.angular)) {
      options.angular = {};
    }
    if (!isType.array(options.angular.modules)) {
      options.angular.modules = null;
    }
    if (!isType.string(options.angular.version)) {
      options.angular.version = null;
    }
    if (!isType.string(options.angular.moduleName)) {
      options.angular.moduleName = null;
    }
    if (!isType.boolean(options.angular.ngFormify)) {
      options.angular.ngFormify = null;
    }
    if (!isType.object(options.angular.httpBackend)) {
      options.angular.httpBackend = {};
    }
    if (!isType.boolean(options.angular.httpBackend.dev)) {
      options.angular.httpBackend.dev = null;
    }
    if (!isType.boolean(options.angular.httpBackend.prod)) {
      options.angular.httpBackend.prod = null;
    }
    if (!isType.string(options.angular.httpBackend.dir)) {
      options.angular.httpBackend.dir = null;
    }
    if (!isType.object(options.angular.templateCache)) {
      options.angular.templateCache = {};
    }
    if (!isType.boolean(options.angular.templateCache.dev)) {
      options.angular.templateCache.dev = null;
    }
    if (!isType.string(options.angular.templateCache.urlPrefix)) {
      options.angular.templateCache.urlPrefix = null;
    }
    if (!isType.boolean(options.angular.templateCache.useAbsolutePaths)) {
      return options.angular.templateCache.useAbsolutePaths = null;
    }
  };
  spaOptions = function() {
    if (!isType.object(options.spa)) {
      options.spa = {};
    }
    if (!isType.string(options.spa.title)) {
      options.spa.title = null;
    }
    if (!isType.string(options.spa.description)) {
      options.spa.description = null;
    }
    if (!isType.object(options.spa.src)) {
      options.spa.src = {};
    }
    if (!isType.string(options.spa.src.filePath)) {
      options.spa.src.filePath = null;
    }
    if (!isType.object(options.spa.dist)) {
      options.spa.dist = {};
    }
    if (!isType.string(options.spa.dist.fileName)) {
      options.spa.dist.fileName = null;
    }
    if (!isType.array(options.spa.placeholders)) {
      return options.spa.placeholders = null;
    }
  };
  minifyOptions = function() {
    if (!isType.object(options.minify)) {
      options.minify = {};
    }
    if (!isType.object(options.minify.css)) {
      options.minify.css = {};
    }
    if (!isType.object(options.minify.html)) {
      options.minify.html = {};
    }
    if (!isType.object(options.minify.js)) {
      options.minify.js = {};
    }
    if (!isType.object(options.minify.spa)) {
      options.minify.spa = {};
    }
    if (!isType.boolean(options.minify.cacheBust)) {
      options.minify.cacheBust = null;
    }
    if (!isType.boolean(options.minify.css.styles)) {
      options.minify.css.styles = null;
    }
    if (!isType.string(options.minify.css.fileName)) {
      options.minify.css.fileName = null;
    }
    if (!isType.boolean(options.minify.css.splitMinFile)) {
      options.minify.css.splitMinFile = null;
    }
    if (!isType.boolean(options.minify.html.views)) {
      options.minify.html.views = null;
    }
    if (!isType.boolean(options.minify.html.templateCache)) {
      options.minify.html.templateCache = null;
    }
    if (!isType.boolean(options.minify.js.scripts)) {
      options.minify.js.scripts = null;
    }
    if (!isType.string(options.minify.js.fileName)) {
      options.minify.js.fileName = null;
    }
    if (!isType.boolean(options.minify.js.mangle)) {
      options.minify.js.mangle = null;
    }
    if (!isType.boolean(options.minify.spa.file)) {
      return options.minify.spa.file = null;
    }
  };
  excludeOptions = function() {
    if (!isType.object(options.exclude)) {
      options.exclude = {};
    }
    if (!isType.object(options.exclude.angular)) {
      options.exclude.angular = {};
    }
    if (!isType.object(options.exclude["default"])) {
      options.exclude["default"] = {};
    }
    if (!isType.object(options.exclude.from)) {
      options.exclude.from = {};
    }
    if (!isType.boolean(options.exclude.spa)) {
      options.exclude.spa = null;
    }
    if (!isType.boolean(options.exclude.angular.files)) {
      options.exclude.angular.files = null;
    }
    if (!isType.boolean(options.exclude.angular.modules)) {
      options.exclude.angular.modules = null;
    }
    if (!isType.object(options.exclude["default"].client)) {
      options.exclude["default"].client = {};
    }
    if (!isType.object(options.exclude["default"].server)) {
      options.exclude["default"].server = {};
    }
    if (!isType.array(options.exclude.from.cacheBust)) {
      options.exclude.from.cacheBust = null;
    }
    if (!isType.object(options.exclude.from.minFile)) {
      options.exclude.from.minFile = {};
    }
    if (!isType.object(options.exclude.from.spaFile)) {
      options.exclude.from.spaFile = {};
    }
    if (!isType.object(options.exclude.from.dist)) {
      options.exclude.from.dist = {};
    }
    if (!isType.array(options.exclude.from.minFile.scripts)) {
      options.exclude.from.minFile.scripts = null;
    }
    if (!isType.array(options.exclude.from.minFile.styles)) {
      options.exclude.from.minFile.styles = null;
    }
    if (!isType.array(options.exclude.from.spaFile.scripts)) {
      options.exclude.from.spaFile.scripts = null;
    }
    if (!isType.array(options.exclude.from.spaFile.styles)) {
      options.exclude.from.spaFile.styles = null;
    }
    if (!isType.array(options.exclude.from.dist.client)) {
      options.exclude.from.dist.client = null;
    }
    if (!isType.array(options.exclude.from.dist.server)) {
      options.exclude.from.dist.server = null;
    }
    if (!isType.boolean(options.exclude["default"].client.files)) {
      options.exclude["default"].client.files = null;
    }
    if (!isType.boolean(options.exclude["default"].server.files)) {
      return options.exclude["default"].server.files = null;
    }
  };
  testOptions = function() {
    if (!isType.object(options.test)) {
      options.test = {};
    }
    if (!isType.object(options.test.client)) {
      options.test.client = {};
    }
    if (!isType.array(options.test.client.browsers)) {
      return options.test.client.browsers = null;
    }
  };
  serverDistOptions = function() {
    if (!isType.string(options.dist.server.fileName)) {
      return options.dist.server.fileName = null;
    }
  };
  serverOptions = function() {
    if (!isType.object(options.server)) {
      options.server = {};
    }
    if (!isType.array(options.server.node_modules)) {
      return options.server.node_modules = null;
    }
  };
  proxyOptions = function() {
    if (!isType.array(options.httpProxy)) {
      return options.httpProxy = null;
    }
  };
  extraCopy = function() {
    if (!isType.array(options.extra.copy.client)) {
      options.extra.copy.client = null;
    }
    if (!isType.array(options.extra.copy.server)) {
      return options.extra.copy.server = null;
    }
  };
  extraCompile = function() {
    if (!isType.array(options.extra.compile.client.coffee)) {
      options.extra.compile.client.coffee = null;
    }
    if (!isType.array(options.extra.compile.client.es6)) {
      options.extra.compile.client.es6 = null;
    }
    if (!isType.array(options.extra.compile.client.less)) {
      options.extra.compile.client.less = null;
    }
    if (!isType.array(options.extra.compile.client.sass)) {
      options.extra.compile.client.sass = null;
    }
    if (!isType.array(options.extra.compile.server.less)) {
      options.extra.compile.server.less = null;
    }
    if (!isType.array(options.extra.compile.server.sass)) {
      return options.extra.compile.server.sass = null;
    }
  };
  extraOptions = function() {
    if (!isType.object(options.extra)) {
      options.extra = {};
    }
    if (!isType.object(options.extra.copy)) {
      options.extra.copy = {};
    }
    if (!isType.object(options.extra.compile)) {
      options.extra.compile = {};
    }
    if (!isType.object(options.extra.compile.client)) {
      options.extra.compile.client = {};
    }
    if (!isType.object(options.extra.compile.server)) {
      options.extra.compile.server = {};
    }
    extraCopy();
    return extraCompile();
  };
  browserOptions = function() {
    if (!isType.object(options.browser)) {
      options.browser = {};
    }
    if (!isType.boolean(options.browser.open)) {
      options.browser.open = null;
    }
    if (!isType.boolean(options.browser.reload)) {
      return options.browser.reload = null;
    }
  };
  buildOptions();
  distAndSrcOptions();
  portOptions();
  orderOptions();
  angularOptions();
  spaOptions();
  minifyOptions();
  excludeOptions();
  testOptions();
  serverDistOptions();
  serverOptions();
  proxyOptions();
  browserOptions();
  extraOptions();
  return options;
};
