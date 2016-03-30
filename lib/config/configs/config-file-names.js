module.exports = function(config) {
  var fileName, getLoadFiles, loadScriptFiles, loadStylesFiles, log, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  getLoadFiles = function(type) {
    return {
      first: "first." + type,
      second: "second." + type,
      third: "third." + type,
      middle: "middle." + type,
      last: "last." + type
    };
  };
  loadScriptFiles = getLoadFiles('js');
  loadStylesFiles = getLoadFiles('css');
  fileName = {
    scripts: {
      load: loadScriptFiles,
      min: config.minify.js.fileName
    },
    styles: {
      load: loadStylesFiles,
      min: config.minify.css.fileName
    },
    views: {
      main: 'views.js',
      min: 'views.min.js'
    }
  };
  config.fileName = fileName;
  test.log('true', config.fileName, 'add fileName to config');
  return config;
};
