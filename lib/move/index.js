"use strict";

// Dependencies
var Fs = require("fs"),
    Path = require("path");

/**
 * Move
 * Moves the executable file into another directory.
 *
 * @name Move
 * @function
 * @param {String} old The old executable path.
 * @param {String} cwd The destination folder (most probably the current working directory).
 * @param {Function} callback The callback function.
 */
function Move(old, cwd, callback) {
    var n = Path.join(cwd, Path.basename(old));
    Fs.rename(old, n, function (err) {
        callback(null, [old, n][Number(!err)]);
    });
}

module.exports = Move;