module.exports = function(config) {
  var format, fs;
  fs = require('fs');
  format = require(config.req.helpers + "/format")();
  return {
    exists: function(_path) {
      var e, error;
      try {
        return fs.lstatSync(_path).isFile();
      } catch (error) {
        e = error;
        return false;
      }
    },
    read: {
      json: function(_path) {
        var data;
        data = fs.readFileSync(_path).toString();
        return JSON.parse(data);
      }
    },
    write: {
      json: function(_path, data, pretty) {
        if (pretty == null) {
          pretty = true;
        }
        data = format.json(data);
        return fs.writeFileSync(_path, data);
      }
    }
  };
};
