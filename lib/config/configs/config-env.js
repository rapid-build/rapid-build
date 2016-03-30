var hasProp = {}.hasOwnProperty;

module.exports = function(config) {
  var ENV_RB_MODE, env, log, resetIsEnv, setIsEnv, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  ENV_RB_MODE = process.env.RB_MODE;
  resetIsEnv = function() {
    var k, ref, results, v;
    ref = env.is;
    results = [];
    for (k in ref) {
      if (!hasProp.call(ref, k)) continue;
      v = ref[k];
      results.push(env.is[k] = false);
    }
    return results;
  };
  setIsEnv = function() {
    var name;
    resetIsEnv();
    name = config.env.name;
    switch (name) {
      case 'default':
        return env.is["default"] = true;
      case 'test':
        env.is["default"] = true;
        env.is.test = true;
        env.is.testClient = true;
        return env.is.testServer = true;
      case 'test:client':
        env.is["default"] = true;
        env.is.test = true;
        return env.is.testClient = true;
      case 'test:server':
        env.is["default"] = true;
        env.is.test = true;
        return env.is.testServer = true;
      case 'dev':
        return env.is.dev = true;
      case 'dev:test':
        env.is.dev = true;
        env.is.test = true;
        env.is.testClient = true;
        return env.is.testServer = true;
      case 'dev:test:client':
        env.is.dev = true;
        env.is.test = true;
        return env.is.testClient = true;
      case 'dev:test:server':
        env.is.dev = true;
        env.is.test = true;
        return env.is.testServer = true;
      case 'prod':
      case 'prod:server':
        return env.is.prod = true;
      case 'prod:test':
        env.is.prod = true;
        env.is.test = true;
        env.is.testClient = true;
        return env.is.testServer = true;
      case 'prod:test:client':
        env.is.prod = true;
        env.is.test = true;
        return env.is.testClient = true;
      case 'prod:test:server':
        env.is.prod = true;
        env.is.test = true;
        return env.is.testServer = true;
    }
  };
  env = {};
  env.name = 'default';
  env.override = !!ENV_RB_MODE;
  env.is = {
    "default": true,
    dev: false,
    prod: false,
    test: false,
    testClient: false,
    testServer: false
  };
  config.env = env;
  config.env.set = function(mode) {
    if (!mode) {
      return;
    }
    config.env.name = mode;
    return setIsEnv();
  };
  if (config.env.override) {
    config.env.set(ENV_RB_MODE);
  }
  test.log('true', config.env, 'add env to config');
  return config;
};
