module.exports = function(config, rbDir) {
  var req;
  req = {
    rb: rbDir,
    app: process.cwd(),
    config: rbDir + "/config/configs",
    plugins: rbDir + "/plugins",
    helpers: rbDir + "/helpers",
    init: rbDir + "/init",
    tasks: rbDir + "/tasks"
  };
  config.req = req;
  return config;
};
