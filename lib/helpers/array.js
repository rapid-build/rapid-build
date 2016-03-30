module.exports = {
  areEqual: function(array1, array2, order) {
    if (order == null) {
      order = false;
    }
    if (!Array.isArray(array1)) {
      return false;
    }
    if (!Array.isArray(array2)) {
      return false;
    }
    if (array1.length !== array2.length) {
      return false;
    }
    if (order) {
      array1.sort();
      array2.sort();
    }
    return JSON.stringify(array1) === JSON.stringify(array2);
  }
};
