// Dependencies
var Spawn = require("child_process").spawn
  , Fs = require("fs")
  , Tmp = require("tmp")
  , Compile = require("./compile")
  , Run = require("./run")
  , Move = require("./move")
  , Ul = require("ul")
  , OneByOne = require("one-by-one")
  , Sliced = require("sliced")
  ;

/**
 * Cobol
 * Runs COBOL code from Node.JS side.
 *
 * @name Cobol
 * @function
 * @param {Function|String|Path} input A function containing a comment with inline COBOL code, the cobol code itself or a path to a COBOL file.
 * @param {Object} options An object containing the following fields:
 *
 *  - `cwd` (String): Where the COBOL code will run (by default in the current working directory)
 *  - `args` (Array): An array of strings to pass to the COBOL process.
 *  - `free` (Boolean): Use free option while compiling with GnuCobol
 *  - `stdin` (Stream): An optional stdin stream used to pipe data to the stdin stream of the COBOL process.
 *  - `stderr` (Stream): An optional stderr stream used to pipe data to the stdin stream of the COBOL process.
 *  - `stdeout` (Stream): An optional stdout stream used to pipe data to the stdin stream of the COBOL process.
 *
 * @param {Function} callback The callback function called with `err`, `stdout` and `stderr`.
 */
function Cobol(input, options, callback) {

    var args = Sliced(arguments);

    if (typeof options === "function") {
        callback = options;
        options = {};
    }

    callback = callback || function () {};

    // Merge the defaults
    options = Ul.merge(options, {
        cwd: process.cwd()
      , free: false
      , args: []
    });

    if (typeof args[1] === "object") {
    //    options = Ul.merge(options, {
    //        stdout: process.stdout
    //      , stderr: process.stderr
    //      , stdin: process.stdin
    //    });
    }

    // File
    if (typeof input === "string" && input.split("\n").length === 1) {
        return OneByOne([
            Compile.bind(this, input, options)
          , function (next, path) {
                Run(path, options, next);
            }
        ], function (err, data) {
            callback(err, data && data.slice(-1)[0]);
        });
    }

    // Comment
    // TODO We should improve this.
    if (typeof input === "function") {
        input = input.toString().slice(17, -4)
    }

    // Code
    if (typeof input === "string") {
        return OneByOne([
            Tmp.file.bind(Tmp)
          , function (next, path) {
                Fs.writeFile(path, input, function (err) {
                    next(err, path);
                });
            }
          , function (next, path) {
                if (typeof args[1] !== "object") {
                    return Cobol(path, next);
                }
                Cobol(path, options, next);
            }
        ], function (err, data) {
            //if (options.autoclose !== false) {
            //    process.nextTick(function () {
            //        process.exit();
            //    });
            //}
            callback(err, data && data.slice(-1)[0]);
        });
    }

    callback(new Error("Incorrect usage."));
}

module.exports = Cobol;
