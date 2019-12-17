- |
  function sum_file_array_size(farr) {
    var divisor = 1048576;
    var total = 0;
    for (var i = 0; i<farr.length; i++) {
      total += farr[i].size
    }
    return Math.ceil(total / divisor);
  }

- |
  function file_size_multiplier(fobj, mult) {
    mult = typeof mult !== 'undefined' ? mult : 1;
    var divisor = 1048576;
    return Math.ceil(mult * fobj.size / divisor);
  }
