module.exports = function(config, gulp) {
  var addFileProps, addTask, api, changeTask, cleanStylesCb, cleanTask, createWatch, events, gWatch, getAppOrRb, getClientOrServer, getDistDir, getDistPath, getFileName, getRelative, htmlWatch, log, path, promiseHelp, q, spaWatch, taskHelp, tasks;
  q = require('q');
  path = require('path');
  gWatch = require('gulp-watch');
  log = require(config.req.helpers + "/log");
  promiseHelp = require(config.req.helpers + "/promise");
  taskHelp = require(config.req.helpers + "/tasks")(config, gulp);
  tasks = {
    clean: require(config.req.tasks + "/clean/clean-dist"),
    coffee: require(config.req.tasks + "/compile/coffee"),
    css: require(config.req.tasks + "/copy/copy-css"),
    es6: require(config.req.tasks + "/compile/es6"),
    html: require(config.req.tasks + "/copy/copy-html"),
    image: require(config.req.tasks + "/copy/copy-images"),
    js: require(config.req.tasks + "/copy/copy-js"),
    less: require(config.req.tasks + "/compile/less"),
    sass: require(config.req.tasks + "/compile/sass"),
    tCache: require(config.req.tasks + "/minify/template-cache"),
    clientTest: require(config.req.tasks + "/test/client/copy-client-tests"),
    serverTest: require(config.req.tasks + "/test/server/copy-server-tests"),
    buildSpa: function() {
      if (!config.build.client) {
        return promiseHelp.get();
      }
      return taskHelp.startTask('watch-build-spa');
    },
    browserSync: function() {
      var browserSync;
      if (!config.build.server) {
        return;
      }
      browserSync = require(config.req.tasks + "/browser/browser-sync");
      return browserSync.restart();
    }
  };
  getAppOrRb = function(file) {
    if (file.path.indexOf(config.src.rb.dir) !== -1) {
      return 'rb';
    }
    return 'app';
  };
  getClientOrServer = function(file) {
    if (file.path.indexOf(config.src[file.rbAppOrRb].server.scripts.dir) === -1) {
      return 'client';
    }
    return 'server';
  };
  getRelative = function(file) {
    var dir;
    dir = path.dirname(file.relative);
    if (dir === '.') {
      return '';
    }
    return dir;
  };
  getFileName = function(file) {
    var fileName;
    fileName = path.basename(file.path);
    return fileName;
  };
  getDistDir = function(file, opts) {
    var dir;
    if (opts == null) {
      opts = {};
    }
    dir = config.dist[file.rbAppOrRb][file.rbClientOrServer][opts.srcType].dir;
    dir = path.join(dir, file.rbRelative);
    return dir;
  };
  getDistPath = function(file, opts) {
    var dPath, extSrc, fileName;
    if (opts == null) {
      opts = {};
    }
    fileName = file.rbFileName;
    if (opts.extDist) {
      extSrc = path.extname(fileName);
      fileName = fileName.replace(extSrc, "." + opts.extDist);
    }
    dPath = path.join(file.rbDistDir, fileName);
    return dPath;
  };
  addFileProps = function(file, opts) {
    if (opts == null) {
      opts = {};
    }
    file.rbAppOrRb = getAppOrRb(file);
    file.rbClientOrServer = getClientOrServer(file);
    file.rbRelative = getRelative(file);
    file.rbFileName = getFileName(file);
    file.rbDistDir = getDistDir(file, opts);
    file.rbDistPath = getDistPath(file, opts);
    return file;
  };
  changeTask = function(taskName, file) {
    return tasks[taskName](config, gulp, {
      watchFile: file
    });
  };
  addTask = function(taskName, file, opts) {
    return changeTask(taskName, file).then(function() {
      if (opts.isTest) {
        return promiseHelp.get();
      }
      if (opts.taskOnly) {
        return promiseHelp.get();
      }
      if (opts.bsReload) {
        return tasks.browserSync();
      }
      return tasks.buildSpa();
    });
  };
  cleanTask = function(taskName, file, opts) {
    if (opts.taskOnly) {
      return changeTask(taskName, file);
    }
    return tasks['clean'](config, gulp, {
      watchFile: file
    }).then(function() {
      if (opts.isTest) {
        return promiseHelp.get();
      }
      if (opts.bsReload) {
        return tasks.browserSync();
      }
      if (opts.cleanCb) {
        return opts.cleanCb(file).then(function() {
          return tasks.buildSpa();
        });
      }
      return tasks.buildSpa();
    });
  };
  events = function(file, taskName, opts) {
    if (opts == null) {
      opts = {};
    }
    log.watch(taskName, file, opts);
    if (taskName === 'build spa') {
      return tasks.buildSpa();
    }
    if (!file) {
      return;
    }
    if (!file.event) {
      return;
    }
    if (!file.path) {
      return;
    }
    if (!taskName) {
      return;
    }
    file = addFileProps(file, opts);
    switch (file.event) {
      case 'change':
        return changeTask(taskName, file);
      case 'unlink':
        return cleanTask(taskName, file, opts);
      case 'add':
        return addTask(taskName, file, opts);
    }
  };
  createWatch = function(_glob, taskName, opts) {
    var defer;
    if (opts == null) {
      opts = {};
    }
    defer = q.defer();
    gWatch(_glob, {
      read: false
    }, function(file) {
      return events(file, taskName, opts);
    }).on('ready', function() {
      var loc, msg;
      loc = opts.loc || 'client';
      if (opts.isTest) {
        loc = loc + " test";
      }
      msg = opts.lang.indexOf('.') !== -1 ? 'file' : 'files';
      console.log(("watching " + loc + " " + opts.lang + " " + msg).yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  htmlWatch = function(views) {
    if (config.angular.templateCache.dev) {
      if (config.exclude["default"].client.files) {
        return promiseHelp.get();
      }
      return createWatch(views, 'tCache', {
        lang: 'html',
        srcType: 'views',
        taskOnly: true,
        logTaskName: 'template cache'
      });
    }
    return createWatch(views, 'html', {
      lang: 'html',
      srcType: 'views',
      bsReload: true
    });
  };
  spaWatch = function(spaFilePath) {
    if (!config.spa.custom) {
      return promiseHelp.get();
    }
    if (config.exclude.spa) {
      return promiseHelp.get();
    }
    return createWatch(spaFilePath, 'build spa', {
      lang: config.spa.dist.file
    });
  };
  cleanStylesCb = function(file) {
    config.internal.deleteFileImports(file.rbAppOrRb, file.rbDistPath);
    return promiseHelp.get();
  };
  api = {
    runTask: function() {
      var clientTestWatches, clientWatches, defer, promises, serverTestWatches, serverWatches, watches;
      defer = q.defer();
      watches = [];
      clientWatches = [
        function() {
          return createWatch(config.glob.src.app.client.images.all, 'image', {
            lang: 'image',
            srcType: 'images',
            bsReload: true
          });
        }, function() {
          return createWatch(config.glob.src.app.client.styles.css, 'css', {
            lang: 'css',
            srcType: 'styles',
            cleanCb: cleanStylesCb
          });
        }, function() {
          return createWatch(config.glob.src.app.client.styles.less, 'less', {
            lang: 'less',
            srcType: 'styles',
            extDist: 'css',
            cleanCb: cleanStylesCb
          });
        }, function() {
          return createWatch(config.glob.src.app.client.styles.sass, 'sass', {
            lang: 'sass',
            srcType: 'styles',
            extDist: 'css',
            cleanCb: cleanStylesCb
          });
        }, function() {
          return createWatch(config.glob.src.app.client.scripts.coffee, 'coffee', {
            lang: 'coffee',
            srcType: 'scripts',
            extDist: 'js'
          });
        }, function() {
          return createWatch(config.glob.src.app.client.scripts.es6, 'es6', {
            lang: 'es6',
            srcType: 'scripts',
            extDist: 'js'
          });
        }, function() {
          return createWatch(config.glob.src.app.client.scripts.js, 'js', {
            lang: 'js',
            srcType: 'scripts'
          });
        }, function() {
          return htmlWatch(config.glob.src.app.client.views.html);
        }, function() {
          return spaWatch(config.spa.src.path);
        }
      ];
      serverWatches = [
        function() {
          return createWatch(config.glob.src.app.server.scripts.js, 'js', {
            lang: 'js',
            srcType: 'scripts',
            loc: 'server',
            bsReload: true
          });
        }, function() {
          return createWatch(config.glob.src.app.server.scripts.es6, 'es6', {
            lang: 'es6',
            srcType: 'scripts',
            extDist: 'js',
            loc: 'server',
            bsReload: true
          });
        }, function() {
          return createWatch(config.glob.src.app.server.scripts.coffee, 'coffee', {
            lang: 'coffee',
            srcType: 'scripts',
            extDist: 'js',
            loc: 'server',
            bsReload: true
          });
        }
      ];
      clientTestWatches = [
        function() {
          return createWatch(config.glob.src.app.client.test.js, 'clientTest', {
            lang: 'js',
            srcType: 'test',
            isTest: true,
            logTaskName: 'client test'
          });
        }, function() {
          return createWatch(config.glob.src.app.client.test.es6, 'clientTest', {
            lang: 'es6',
            srcType: 'test',
            extDist: 'js',
            isTest: true,
            logTaskName: 'client test'
          });
        }, function() {
          return createWatch(config.glob.src.app.client.test.coffee, 'clientTest', {
            lang: 'coffee',
            srcType: 'test',
            extDist: 'js',
            isTest: true,
            logTaskName: 'client test'
          });
        }
      ];
      serverTestWatches = [
        function() {
          return createWatch(config.glob.src.app.server.test.js, 'serverTest', {
            lang: 'js',
            srcType: 'test',
            loc: 'server',
            isTest: true,
            logTaskName: 'server test'
          });
        }, function() {
          return createWatch(config.glob.src.app.server.test.es6, 'serverTest', {
            lang: 'es6',
            srcType: 'test',
            extDist: 'js',
            loc: 'server',
            isTest: true,
            logTaskName: 'server test'
          });
        }, function() {
          return createWatch(config.glob.src.app.server.test.coffee, 'serverTest', {
            lang: 'coffee',
            srcType: 'test',
            extDist: 'js',
            loc: 'server',
            isTest: true,
            logTaskName: 'server test'
          });
        }
      ];
      if (config.build.client) {
        if (config.env.is.test) {
          if (config.env.is.testClient) {
            watches = watches.concat(clientWatches, clientTestWatches);
          }
        } else {
          watches = watches.concat(clientWatches);
        }
      }
      if (config.build.server) {
        if (config.env.is.test) {
          if (config.env.is.testServer) {
            watches = watches.concat(serverWatches, serverTestWatches);
          }
        } else {
          watches = watches.concat(serverWatches);
        }
      }
      promises = watches.map(function(watch) {
        return watch();
      });
      q.all(promises).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
