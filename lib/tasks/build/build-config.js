module.exports = function(config) {
  var api, configHelp;
  configHelp = require(config.req.helpers + "/config")(config);
  api = {
    runTask: function() {
      return configHelp.buildFile(true);
    }
  };
  return api.runTask();
};
