module.exports = function(config, gulp) {
  var api, atImport, path, postcss, q;
  q = require('q');
  path = require('path');
  postcss = require('postcss');
  atImport = require('postcss-import');
  api = {
    runTask: function() {
      var defer, dest, ext, fileName, minFile, opts, src;
      defer = q.defer();
      ext = '.css';
      fileName = path.basename(config.fileName.styles.min, ext);
      src = config.temp.client.styles.dir;
      src = path.join(src, "{" + fileName + ext + "," + fileName + ".*" + ext + "}");
      dest = config.temp.client.styles.dir;
      minFile = config.temp.client.styles.min.file;
      opts = {
        root: config.dist.app.client.dir
      };
      gulp.src(src).on('data', function(file) {
        var css, output;
        css = file.contents;
        if (!css) {
          return;
        }
        css = css.toString();
        output = postcss().use(atImport(opts)).process(css).css;
        return file.contents = new Buffer(output);
      }).pipe(gulp.dest(dest)).on('end', function() {
        console.log(("inlined css imports in " + minFile).yellow);
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask();
};
