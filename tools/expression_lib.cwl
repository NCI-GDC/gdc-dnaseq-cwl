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

- |
  function fastq_files_size(forward, reverse) {
    var divisor = 1048576;
    if (reverse == null) {
      return Math.ceil(forward.size / divisor)
    } else {
      return Math.ceil((forward.size + reverse.size) / divisor)
    }
  }
