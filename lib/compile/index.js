var Which = require("which")
  , Exec = require("child_process").exec
  , OArgv = require("oargv")
  , Path = require("path")
  ;

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

function Compile(input, options, callback) {
    CheckCobc(function (exists) {
        if (!exists) {
            return callback(new Error("Couldn't find the cobc executable in the PATH. Make sure you installed Open Cobol."));
        }
        Exec(OArgv({
            x: true
          , _: input
        }, "cobc"), {
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
