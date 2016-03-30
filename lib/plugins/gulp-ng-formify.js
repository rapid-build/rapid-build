var PLUGIN_NAME, PluginError, closeTag, closeTagRegEx, gulpNgFormify, gutil, ngFormify, openTag, openTagRegEx, through;

PLUGIN_NAME = 'gulp-ng-formify';

through = require('through2');

gutil = require('gulp-util');

PluginError = gutil.PluginErrors;

openTagRegEx = new RegExp('<\\s*\\bform', 'gm');

closeTagRegEx = new RegExp('<\\s*/\\s*\\bform', 'gm');

openTag = '<ng:form';

closeTag = '</ng:form';

ngFormify = function(contents) {
  return contents.replace(openTagRegEx, openTag).replace(closeTagRegEx, closeTag);
};

gulpNgFormify = function() {
  return through.obj(function(file, enc, cb) {
    var contents;
    if (file.isNull()) {
      return cb(null, file);
    }
    if (file.isStream()) {
      return cb(new PluginError(PLUGIN_NAME, 'streaming not supported'));
    }
    if (file.isBuffer()) {
      contents = ngFormify(file.contents.toString());
      file.contents = new Buffer(contents);
    }
    return cb(null, file);
  });
};

module.exports = gulpNgFormify;
