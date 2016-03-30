module.exports = function(config, options) {
  var build, log, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  build = {};
  build.client = options.build.client === false ? false : true;
  build.server = options.build.server === false ? false : true;
  if (!(build.client || build.server)) {
    process.on('exit', function() {
      var msg;
      msg = 'Atleast one build, client or server must be enabled.';
      return console.error(msg.error);
    }).exit(1);
  }
  config.build = build;
  test.log('true', config.build, 'add build to config');
  return config;
};
