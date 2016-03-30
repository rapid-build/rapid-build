module.exports = function(config, gulp) {
  var Blueprint, ProdFiles, api, buildTask, fse, log, path, pathHelp, promiseHelp, q, setBlueprint, setMultiProdFiles, setProdFiles;
  q = require('q');
  path = require('path');
  fse = require('fs-extra');
  log = require(config.req.helpers + "/log");
  pathHelp = require(config.req.helpers + "/path");
  promiseHelp = require(config.req.helpers + "/promise");
  Blueprint = {};
  ProdFiles = {
    client: {
      scripts: [],
      styles: []
    }
  };
  buildTask = function() {
    var defer, format, jsonFile;
    defer = q.defer();
    format = {
      spaces: '\t'
    };
    jsonFile = config.generated.pkg.files.prodFiles;
    fse.writeJson(jsonFile, ProdFiles, format, function(e) {
      console.log('built prod-files.json'.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  setProdFiles = function(type) {
    var dir, file, files, i, j, len, minFilePath, ref;
    files = [];
    dir = config.dist.app.client[type].dir;
    ref = Blueprint[type];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      file = ref[i];
      if (file.type === 'exclude') {
        files.push(file.files);
      } else {
        minFilePath = path.join(dir, file.name);
        minFilePath = pathHelp.format(minFilePath);
        files.push(minFilePath);
      }
    }
    ProdFiles.client[type] = files;
    return promiseHelp.get();
  };
  setBlueprint = function() {
    var file;
    file = config.generated.pkg.files.prodFilesBlueprint;
    Blueprint = require(file);
    return promiseHelp.get();
  };
  setMultiProdFiles = function() {
    var defer;
    defer = q.defer();
    q.all([setProdFiles('scripts'), setProdFiles('styles')]).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function() {
      var defer, tasks;
      defer = q.defer();
      tasks = [
        function() {
          return setBlueprint();
        }, function() {
          return setMultiProdFiles();
        }, function() {
          return buildTask();
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
