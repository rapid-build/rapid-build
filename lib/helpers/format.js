module.exports = function() {
  var get;
  get = {
    paths: function(paths, opts) {
      var _paths;
      if (opts == null) {
        opts = {};
      }
      opts.join = opts.join || false;
      opts.htmlTag = opts.htmlTag || null;
      opts.lineEnding = opts.lineEnding || '\n';
      _paths = [];
      paths.forEach((function(_this) {
        return function(_path) {
          if (opts.htmlTag) {
            return _paths.push(_this.html[opts.htmlTag](_path));
          }
        };
      })(this));
      if (opts.join) {
        _paths = _paths.join(opts.lineEnding);
      }
      return _paths;
    },
    html: {
      styles: function(_path) {
        return "<link rel=\"stylesheet\" href=\"" + _path + "\" />";
      },
      scripts: function(_path) {
        return "<script src=\"" + _path + "\"></script>";
      }
    }
  };
  return {
    json: function(data, pretty) {
      if (pretty == null) {
        pretty = true;
      }
      if (pretty) {
        return JSON.stringify(data, null, '\t');
      }
      return JSON.stringify(data);
    },
    paths: {
      to: {
        html: function(paths, htmlTag, opts) {
          if (opts == null) {
            opts = {};
          }
          opts.htmlTag = htmlTag;
          return get.paths(paths, opts);
        }
      }
    }
  };
};
