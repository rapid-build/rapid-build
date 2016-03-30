module.exports = function(config, gulp, taskOpts) {
  var api, buildTask, format, getData, getFilesJson, gulpif, moduleHelp, path, pathHelp, promiseHelp, q, rename, replace, runReplace, template;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  path = require('path');
  gulpif = require('gulp-if');
  rename = require('gulp-rename');
  replace = require('gulp-replace');
  template = require('gulp-template');
  pathHelp = require(config.req.helpers + "/path");
  moduleHelp = require(config.req.helpers + "/module");
  promiseHelp = require(config.req.helpers + "/promise");
  format = require(config.req.helpers + "/format")();
  runReplace = function(type) {
    var key, newKey, placeholders, replacePH;
    newKey = "<%= " + type + " %>";
    key = "<!--#include " + type + "-->";
    placeholders = config.spa.placeholders;
    replacePH = true;
    if (placeholders.indexOf('all') !== -1) {
      replacePH = false;
    } else if (placeholders.indexOf(type) !== -1) {
      replacePH = false;
    }
    return gulpif(replacePH, replace(key, newKey));
  };
  buildTask = function(src, dest, file, data) {
    var defer;
    if (data == null) {
      data = {};
    }
    defer = q.defer();
    gulp.src(src).pipe(rename(file)).pipe(runReplace('description')).pipe(runReplace('moduleName')).pipe(runReplace('scripts')).pipe(runReplace('styles')).pipe(runReplace('title')).pipe(template(data)).pipe(gulp.dest(dest)).on('end', function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  getFilesJson = function(jsonEnvFile) {
    var files;
    jsonEnvFile = path.join(config.generated.pkg.files.path, jsonEnvFile);
    moduleHelp.cache["delete"](jsonEnvFile);
    files = require(jsonEnvFile).client;
    files = pathHelp.removeLocPartial(files, config.dist.app.client.dir);
    files.styles = format.paths.to.html(files.styles, 'styles', {
      join: true,
      lineEnding: '\n\t'
    });
    files.scripts = format.paths.to.html(files.scripts, 'scripts', {
      join: true,
      lineEnding: '\n\t'
    });
    return files;
  };
  getData = function(jsonEnvFile) {
    var data, files;
    files = getFilesJson(jsonEnvFile);
    return data = {
      scripts: files.scripts,
      styles: files.styles,
      moduleName: config.angular.moduleName,
      title: config.spa.title,
      description: config.spa.description
    };
  };
  api = {
    runTask: function(env) {
      var data, defer, json, tasks;
      if (!config.build.client) {
        return promiseHelp.get();
      }
      if (config.exclude.spa) {
        return promiseHelp.get();
      }
      defer = q.defer();
      json = env === 'prod' ? 'prod-files.json' : 'files.json';
      data = getData(json);
      tasks = [
        function() {
          return buildTask(config.spa.src.path, config.dist.app.client.dir, config.spa.dist.file, data);
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask(taskOpts.env);
};
