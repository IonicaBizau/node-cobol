// Dependencies
var Cobol = require("../lib")
  , Abs = require("abs")
  ;

// Get the input
var input = process.argv[2];
if (!input) {
    return console.log("Usage: node others.js file.cobc additional arguments");
}

// Run the input
Cobol(Abs(input), {
    args: process.argv.slice(3)
  , stdin: process.stdin
  , stdout: process.stdout
  , stderr: process.stderr
}, function (err) {
    if (err) {
        console.log(err);
    }
});
