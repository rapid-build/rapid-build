module.exports = {
  cache: {
    get: function(id) {
      var cache;
      cache = require.cache;
      if (!(cache || cache.length)) {
        return null;
      }
      return cache[id];
    },
    getIds: function() {
      var cache;
      cache = require.cache;
      if (!(cache || cache.length)) {
        return [];
      }
      return Object.keys(cache);
    },
    "delete": function(id) {
      var children, file, files, i, isCached, len;
      if (!id) {
        return;
      }
      files = require.cache[id];
      isCached = !!files;
      if (!isCached) {
        return;
      }
      children = files.children;
      if (children.length) {
        for (i = 0, len = children.length; i < len; i++) {
          file = children[i];
          this["delete"](file.id);
        }
      }
      return delete require.cache[id];
    }
  }
};
