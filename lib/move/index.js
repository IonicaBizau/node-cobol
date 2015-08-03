var Fs = require("fs")
  , Path = require("path")
  ;

function Move(old, cwd, callback) {
    var n =  Path.join(cwd, Path.basename(old));
    Fs.rename(
        old
      , n
      , function (err) {
            callback(null, [old, n][Number(!err)])
        }
    )
}

module.exports = Move;
