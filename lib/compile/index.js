// Dependencies
var Which = require("which")
  , Exec = require("child_process").exec
  , OArgv = require("oargv")
  , Path = require("path")
  ;

/**
 * CheckCobc
 * Checks if `cobc` exists as executable.
 *
 * @name CheckCobc
 * @function
 * @param {Function} callback The callback function.
 */
var _cobcExists = false;
function CheckCobc(callback) {
    if (_cobcExists) {
        return process.nextTick(function () {
            callback(_cobcExists);
        });
    }
    Which("cobc", function (err) {
        _cobcExists = !err;
        callback(_cobcExists);
    });
}

/**
 * Compile
 * Compiles the cobol file.
 *
 * @name Compile
 * @function
 * @param {String} input The path to the cobol file.
 * @param {Object} options An object containing the following fields:
 * @param {Function} callback The callback function.
 */
function Compile(input, options, callback) {
    CheckCobc(function (exists) {
        if (!exists) {
            return callback(new Error("Couldn't find the cobc executable in the PATH. Make sure you installed Open Cobol."));
        }

        var args = {
            x: true
          , _: input
        };
        if (options.free) {
            args.free = options.free;
        }

        Exec(OArgv(args, "cobc"), {
            cwd: options.cwd
        }, function (err, stdout, stderr) {
            if (stderr || err) {
                return callback(stderr || err);
            }
            var output = Path.join(options.cwd, Path.basename(input).slice(0, -4));
            callback(null, output);
        })
    });
}

module.exports = Compile;
