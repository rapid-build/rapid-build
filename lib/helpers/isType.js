module.exports = {
  array: function(v) {
    return Array.isArray(v);
  },
  boolean: function(v) {
    return typeof v === 'boolean';
  },
  "function": function(v) {
    return typeof v === 'function';
  },
  int: function(v) {
    if (!this.number(v)) {
      return false;
    }
    return v % 1 === 0;
  },
  "null": function(v) {
    return v === null;
  },
  number: function(v) {
    if (this.string(v)) {
      return false;
    }
    return !isNaN(v);
  },
  object: function(v) {
    if (typeof v !== 'object') {
      return false;
    }
    if (v === null) {
      return false;
    }
    if (this.array(v)) {
      return false;
    }
    return true;
  },
  string: function(v) {
    return typeof v === 'string';
  },
  undefined: function(v) {
    return v === void 0;
  }
};
