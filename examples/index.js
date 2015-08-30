// Dependencies
var Cobol = require("../lib");

// Execute some COBOL snippets
Cobol(function () { /*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       PROCEDURE DIVISION.

       PROGRAM-BEGIN.
           DISPLAY "Hello world".

       PROGRAM-DONE.
           STOP RUN.
*/ }, function (err, data) {
    console.log(err || data);
});
// => "Hello World"

Cobol(__dirname + "/args.cbl", {
    args: ["Alice"]
}, function (err, data) {
    console.log(err || data);
});
// => "Your name is: Alice"

// This will read data from stdin
Cobol(function () { /*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. APP.
      *> http://stackoverflow.com/q/938760/1420197

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT SYSIN ASSIGN TO KEYBOARD ORGANIZATION LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SYSIN.
       01 ln PIC X(64).
          88 EOF VALUE HIGH-VALUES.
       WORKING-STORAGE SECTION.
       PROCEDURE DIVISION.
       DISPLAY "Write something and then press the <Enter> key"
       OPEN INPUT SYSIN
       READ SYSIN
       AT END SET EOF TO TRUE
       END-READ
       PERFORM UNTIL EOF
       DISPLAY "You wrote: ", ln
       DISPLAY "------------"
       READ SYSIN
       AT END SET EOF TO TRUE
       END-READ
       END-PERFORM
       CLOSE SYSIN
       STOP RUN.
*/ }, {
    stdin: process.stdin
  , stdout: process.stdout
}, function (err) {
    if (err) {
        console.log(err);
    }
});
// => Write something and then press the <Enter> key
// <= Hi there!
// => You wrote: Hi there!
// => ------------
