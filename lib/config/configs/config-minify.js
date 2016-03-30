module.exports = function(config, options) {
  var cacheBustOpt, getFileName, getOption, isType, log, minify, test;
  log = require(config.req.helpers + "/log");
  test = require(config.req.helpers + "/test")();
  isType = require(config.req.helpers + "/isType");
  getOption = function(type, opt) {
    opt = options.minify[type][opt];
    if (isType["null"](opt)) {
      return true;
    }
    return opt;
  };
  getFileName = function(type, lang) {
    var ext, fName, hasExt;
    ext = "." + lang;
    fName = options.minify[lang].fileName;
    if (!fName) {
      return type + ".min" + ext;
    }
    hasExt = fName.indexOf(ext) !== -1;
    if (!hasExt) {
      fName += ext;
    }
    return fName;
  };
  minify = {
    css: {
      styles: getOption('css', 'styles'),
      splitMinFile: getOption('css', 'splitMinFile'),
      fileName: getFileName('styles', 'css')
    },
    js: {
      scripts: getOption('js', 'scripts'),
      mangle: getOption('js', 'mangle'),
      fileName: getFileName('scripts', 'js')
    },
    html: {
      views: getOption('html', 'views'),
      templateCache: getOption('html', 'templateCache'),
      options: {
        collapseWhitespace: true,
        removeComments: true,
        removeEmptyElements: false,
        removeEmptyAttributes: false,
        ignoreCustomFragments: [/<!--\s*?#\s*?include.*?-->/ig]
      }
    },
    spa: {
      file: getOption('spa', 'file')
    }
  };
  cacheBustOpt = options.minify.cacheBust;
  minify.cacheBust = isType["null"](cacheBustOpt) ? true : cacheBustOpt;
  config.minify = minify;
  test.log('true', config.minify, 'add minify to config');
  return config;
};
