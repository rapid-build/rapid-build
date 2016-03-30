module.exports = function() {
  var conditions, getFromFile, path;
  path = require('path');
  conditions = ['false', 'true'];
  getFromFile = function() {
    var ext;
    ext = path.extname(module.parent.filename);
    return path.basename(module.parent.filename, ext);
  };
  return {
    "false": function(from, condition, v, msg) {
      if (!v) {
        return;
      }
      msg = msg || (condition + " test failed");
      return console.error(("ERROR " + from + ": " + msg).error);
    },
    "true": function(from, condition, v, msg) {
      if (!!v) {
        return;
      }
      msg = msg || (condition + " test failed");
      return console.error(("ERROR " + from + ": " + msg).error);
    },
    log: function(condition, v, msg) {
      var from;
      from = "(" + (getFromFile()) + ")";
      if (conditions.indexOf(condition) === -1) {
        return console.error(("ERROR " + from + ": \"" + condition + "\" is not a supported test condition").error);
      }
      return this[condition](from, condition, v, msg);
    }
  };
};
