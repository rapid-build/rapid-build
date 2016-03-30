module.exports = function(config, options) {
  var angular, httpBackendDir, log, modules, path, removeRbMocksModule, test;
  path = require('path');
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  modules = ['ngMockE2E', 'ngResource', 'ngRoute', 'ngSanitize'];
  if (options.exclude.angular.modules) {
    modules.splice(1, modules.length - 1);
  }
  angular = {};
  angular.ngFormify = options.angular.ngFormify || false;
  httpBackendDir = options.angular.httpBackend.dir || 'mocks';
  httpBackendDir = path.join(config.src.app.client.scripts.dir, httpBackendDir);
  angular.httpBackend = {};
  angular.httpBackend.dev = options.angular.httpBackend.dev || false;
  angular.httpBackend.prod = options.angular.httpBackend.prod || false;
  angular.httpBackend.enabled = false;
  angular.httpBackend.dir = httpBackendDir;
  angular.modules = options.angular.modules || [];
  angular.modules = modules.concat(angular.modules);
  angular.version = options.angular.version || '1.x';
  angular.moduleName = options.angular.moduleName || 'app';
  angular.templateCache = {};
  angular.templateCache.dev = options.angular.templateCache.dev || false;
  angular.templateCache.urlPrefix = options.angular.templateCache.urlPrefix || '';
  angular.templateCache.useAbsolutePaths = options.angular.templateCache.useAbsolutePaths || false;
  angular.bowerDeps = {
    'angular': angular.version,
    'angular-mocks': angular.version,
    'angular-resource': angular.version,
    'angular-route': angular.version,
    'angular-sanitize': angular.version
  };
  removeRbMocksModule = function() {
    return angular.modules.splice(0, 1);
  };
  angular.removeRbMocksModule = function() {
    if (config.env.is.prod) {
      if (!angular.httpBackend.prod) {
        return removeRbMocksModule();
      }
    } else if (!angular.httpBackend.dev) {
      return removeRbMocksModule();
    }
  };
  angular.updateHttpBackendStatus = function() {
    var enabled, httpBackendDev, httpBackendProd, isDefaultOrDev, isProd, isTest;
    isDefaultOrDev = config.env.is["default"] || config.env.is.dev;
    isProd = config.env.is.prod;
    isTest = config.env.is.testClient;
    httpBackendDev = angular.httpBackend.dev;
    httpBackendProd = angular.httpBackend.prod;
    if (isDefaultOrDev && httpBackendDev) {
      enabled = true;
    }
    if (isProd && httpBackendProd) {
      enabled = true;
    }
    if (isTest && httpBackendDev && !isProd) {
      enabled = true;
    }
    if (isTest && httpBackendProd && isProd) {
      enabled = true;
    }
    return config.angular.httpBackend.enabled = !!enabled;
  };
  config.angular = angular;
  test.log('true', config.angular, 'add angular to config');
  return config;
};
