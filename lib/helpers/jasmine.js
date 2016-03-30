module.exports = function(config) {
  var Jasmine, Reporter, getHelperFilePath, isType, jasmine, jasmineExpect, moduleHelp, path, q;
  q = require('q');
  path = require('path');
  Jasmine = require('jasmine');
  Reporter = require('jasmine-terminal-reporter');
  isType = require(config.req.helpers + "/isType");
  moduleHelp = require(config.req.helpers + "/module");
  jasmineExpect = path.join(config.node_modules.rb.dist.modules['jasmine-expect'], 'index.js');
  getHelperFilePath = function(file) {
    if (!config.rb.isSymlink) {
      return file;
    }
    file = file.replace(config.node_modules.app.src.dir, config.node_modules.rb.src.dir);
    file = file.replace(config.node_modules.rb.src.relPath, 'node_modules');
    return file;
  };
  return jasmine = {
    defer: q.defer(),
    files: [],
    jasmine: null,
    results: {
      status: null,
      total: 0,
      passed: 0,
      failed: 0,
      failedSpecs: []
    },
    init: function(files) {
      this._setJasmine()._setFiles(files)._setConfig()._setOnComplete()._addReporter();
      return this;
    },
    execute: function() {
      this.jasmine.execute();
      return this.defer.promise;
    },
    reExecute: function() {
      this._deleteCache();
      this.jasmine.execute();
      return this.defer.promise;
    },
    getResults: function() {
      return this.results;
    },
    _setJasmine: function() {
      this.jasmine = new Jasmine();
      return this;
    },
    _setFiles: function(files) {
      this.files = !isType.array(files) ? [files] : files;
      return this;
    },
    _setConfig: function() {
      this.jasmine.loadConfig({
        spec_dir: '',
        spec_files: this.files,
        helpers: [jasmineExpect]
      });
      return this;
    },
    _setOnComplete: function(defer) {
      this.jasmine.onComplete((function(_this) {
        return function(passed) {
          _this.results.status = passed ? 'passed' : 'failed';
          return _this.defer.resolve();
        };
      })(this));
      return this;
    },
    _addReporter: function() {
      this.jasmine.addReporter(new Reporter({
        isVerbose: false,
        showColors: true,
        includeStackTrace: false
      }));
      this.jasmine.addReporter({
        specDone: (function(_this) {
          return function(result) {
            _this.results.total++;
            if (result.status === 'passed') {
              return _this.results.passed++;
            }
            _this.results.failed++;
            return _this.results.failedSpecs.push(result.fullName);
          };
        })(this)
      });
      return this;
    },
    _deleteCache: function() {
      this._deleteCacheSpecFiles();
      this._deleteHelperFiles();
      return this;
    },
    _deleteCacheSpecFiles: function() {
      var file, i, len, specFiles;
      specFiles = this.jasmine.specFiles;
      if (!specFiles.length) {
        return this;
      }
      for (i = 0, len = specFiles.length; i < len; i++) {
        file = specFiles[i];
        file = path.normalize(file);
        moduleHelp.cache["delete"](file);
      }
      return this;
    },
    _deleteHelperFiles: function() {
      var file, helperFiles, i, len;
      helperFiles = this.jasmine.helperFiles;
      if (!helperFiles.length) {
        return this;
      }
      for (i = 0, len = helperFiles.length; i < len; i++) {
        file = helperFiles[i];
        file = path.normalize(file);
        moduleHelp.cache["delete"](getHelperFilePath(file));
      }
      return this;
    }
  };
};
