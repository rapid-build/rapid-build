module.exports = {
  json: function(v, prefix) {
    if (prefix) {
      return console.log(prefix, JSON.stringify(v, null, '\t'));
    } else {
      return console.log(JSON.stringify(v, null, '\t'));
    }
  },
  watch: function(taskName, file, opts) {
    if (opts == null) {
      opts = {};
    }
    taskName = opts.logTaskName || taskName;
    return console.log((taskName + " " + file.event + ": " + file.path).yellow);
  }
};
