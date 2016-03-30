module.exports = function(gulp, config) {
  var defer, gulpSequence, q, taskHelp;
  q = require('q');
  gulpSequence = require('gulp-sequence').use(gulp);
  taskHelp = require(config.req.helpers + "/tasks")(config, gulp);
  defer = q.defer();
  gulp.task(config.rb.tasks["default"], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "common-server", config.rb.prefix.task + "build-spa", config.rb.prefix.task + "start-server", config.rb.prefix.task + "open-browser", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['test'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.tasks['test:client'], config.rb.tasks['test:server'], cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['test:client'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "build-spa", config.rb.prefix.task + "common-test-client", config.rb.prefix.task + "run-client-tests", cb)(function() {
      if (!taskHelp.wasCalledFrom(config.rb.tasks['test'])) {
        return defer.resolve(config);
      }
    });
  });
  gulp.task(config.rb.tasks['test:server'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-server", config.rb.prefix.task + "start-server", config.rb.prefix.task + "common-test-server", config.rb.prefix.task + "stop-server", cb)(function() {
      if (!taskHelp.wasCalledFrom(config.rb.tasks['test'])) {
        return defer.resolve(config);
      }
    });
  });
  gulp.task(config.rb.tasks.dev, [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "common-server", config.rb.prefix.task + "build-spa", config.rb.prefix.task + "start-server:dev", config.rb.prefix.task + "browser-sync", config.rb.prefix.task + "watch", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['dev:test'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "build-spa", config.rb.prefix.task + "common-test-client", config.rb.prefix.task + "run-client-tests:dev", config.rb.prefix.task + "common-server", config.rb.prefix.task + "copy-server-tests", config.rb.prefix.task + "start-server:dev", config.rb.prefix.task + "browser-sync", config.rb.prefix.task + "run-server-tests:dev", config.rb.prefix.task + "watch", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['dev:test:client'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "build-spa", config.rb.prefix.task + "common-test-client", config.rb.prefix.task + "run-client-tests:dev", config.rb.prefix.task + "watch", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['dev:test:server'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-server", config.rb.prefix.task + "copy-server-tests", config.rb.prefix.task + "start-server:dev", config.rb.prefix.task + "browser-sync", config.rb.prefix.task + "run-server-tests:dev", config.rb.prefix.task + "watch", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks.prod, [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "common-server", [config.rb.prefix.task + "minify-client", config.rb.prefix.task + "minify-server"], cb)(function() {
      if (!taskHelp.wasCalledFrom(config.rb.tasks['prod:server'])) {
        return defer.resolve(config);
      }
    });
  });
  gulp.task(config.rb.tasks['prod:server'], [config.rb.tasks.prod], function(cb) {
    return gulpSequence(config.rb.prefix.task + "start-server", config.rb.prefix.task + "open-browser", cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['prod:test'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.tasks['prod:test:client'], config.rb.tasks['prod:test:server'], cb)(function() {
      return defer.resolve(config);
    });
  });
  gulp.task(config.rb.tasks['prod:test:client'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-client", config.rb.prefix.task + "minify-client", config.rb.prefix.task + "common-test-client", config.rb.prefix.task + "run-client-tests", config.rb.prefix.task + "clean-client-test-dist", cb)(function() {
      if (!taskHelp.wasCalledFrom(config.rb.tasks['prod:test'])) {
        return defer.resolve(config);
      }
    });
  });
  gulp.task(config.rb.tasks['prod:test:server'], [config.rb.prefix.task + "common"], function(cb) {
    return gulpSequence(config.rb.prefix.task + "common-server", config.rb.prefix.task + "minify-server", config.rb.prefix.task + "start-server", config.rb.prefix.task + "common-test-server", config.rb.prefix.task + "clean-server-test-dist", config.rb.prefix.task + "stop-server", cb)(function() {
      if (!taskHelp.wasCalledFrom(config.rb.tasks['prod:test'])) {
        return defer.resolve(config);
      }
    });
  });
  return defer.promise;
};
