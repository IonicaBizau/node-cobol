[![cobol](http://i.imgur.com/DutRzDr.png)](#)

# cobol [![PayPal](https://img.shields.io/badge/%24-paypal-f39c12.svg)][paypal-donations] [![Version](https://img.shields.io/npm/v/cobol.svg)](https://www.npmjs.com/package/cobol) [![Downloads](https://img.shields.io/npm/dt/cobol.svg)](https://www.npmjs.com/package/cobol) [![Get help on Codementor](https://cdn.codementor.io/badges/get_help_github.svg)](https://www.codementor.io/johnnyb?utm_source=github&utm_medium=button&utm_term=johnnyb&utm_campaign=github)

> COBOL bridge for NodeJS which allows you to run COBOL code from NodeJS.

## Can I use this on production?

Of course, you can! It's production ready! If you ever did such a thing, [ping me (@IonicaBizau)](https://twitter.com/IonicaBizau). :boom: :dizzy:

## Installation

Currently GNUCobol is required. If you are using a debian-based distribution you can install it using:

```sh
$ sudo apt-get install open-cobol
```

:bulb: It would be interesting to fallback into a COBOL compiler written in NodeJS. [Contributions are welcome!][contributing] :smile:

Then, install the `cobol` package.

```sh
$ npm i cobol
```

## Example

```js
// Dependencies
var Cobol = require("cobol");

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
```

## Documentation

### `Cobol(input, options, callback)`
Runs COBOL code from Node.JS side.

#### Params
- **Function|String|Path** `input`: A function containing a comment with inline COBOL code, the cobol code itself or a path to a COBOL file.
- **Object** `options`: An object containing the following fields:
 - `cwd` (String): Where the COBOL code will run (by default in the current working directory)
 - `args` (Array): An array of strings to pass to the COBOL process.
 - `free` (Boolean): Use free option while compiling with GnuCobol
 - `stdin` (Stream): An optional stdin stream used to pipe data to the stdin stream of the COBOL process.
 - `stderr` (Stream): An optional stderr stream used to pipe data to the stdin stream of the COBOL process.
 - `stdeout` (Stream): An optional stdout stream used to pipe data to the stdin stream of the COBOL process.
- **Function** `callback`: The callback function called with `err`, `stdout` and `stderr`.

## Press Highlights

This project seems to more popular than I expected. :smile: If you wrote or found an article about this project which is not added in this list, [add it][contributing].

 - [Calling 1959 from your Web code: A COBOL bridge for Node.js](http://arstechnica.com/information-technology/2015/08/calling-1959-from-your-web-code-a-cobol-bridge-for-node-js/) ([ArsTechnica](http://arstechnica.com/), by [Sean Gallagher](http://arstechnica.com/author/sean-gallagher/))
 - [Cobol -- yes, Cobol -- gets a bridge to Node.js](http://www.infoworld.com/article/2972314/application-development/cobol-nodejs-bridge.html) ([InfoWorld](http://www.infoworld.com/), by [Paul Krill](http://www.infoworld.com/author/Paul-Krill/))
 - [Ein COBOL-Plug-in für Node.js](http://www.heise.de/newsticker/meldung/Ein-COBOL-Plug-in-fuer-Node-js-2783225.html) ([Heise Online](http://heise.de), by [Alexander Neumann](http://www.heise.de/ix/editors/ix_redakteur_907177.html))
 - [Dit krijg je als je Node.js met COBOL kruist](http://webwereld.nl/open-source/88040-dit-krijg-je-als-je-node-js-met-cobol-kruist) ([Webwereld](http://webwereld.nl/), by [Chris Koenis](http://webwereld.nl/auteur/chris-koenis))
 - [COBOL for Node.js](http://www.i-programmer.info/news/98-languages/8904-cobol-for-nodejs.html) ([I Programmer](http://www.i-programmer.info/), by [Kay Ewbank](https://twitter.com/KayEwbank))
 - [Nagyon durva: Már COBOL-ból is lehet programozni a Node.js-t](http://prog.hu/hirek/4012/nagyon-durva-mar-cobol-bol-is-lehet-programozni-a-node-js-t) ([prog.hu](http://prog.hu/), by [Sting](http://prog.hu/azonosito/info/Sting?pop=1))
 - [Micro Focus Updates COBOL for Visual Studio 2015](http://www.eweek.com/developer/micro-focus-updates-cobol-for-visual-studio-2015.html) ([eWeek](http://eweek.com/), by [Darryl K. Taft](http://www.eweek.com/cp/bio/Darryl-K.-Taft/))
 - [Sur GitHub, un projet relie Cobol et Node.js](http://www.lemondeinformatique.fr/actualites/lire-sur-github-un-projet-relie-cobol-et-nodejs-62116.html) ([LeMondeInformatique](http://lemondeinformatique.fr/), by [Maryse Gros avec IDG News Service](mailto:redac_weblmi@it-news-info.com))
 - [3 open source projects for modern COBOL development](http://opensource.com/life/15/10/open-source-cobol-development) ([OpenSource.com](http://opensource.com/), by [Joshua Allen Holm](http://opensource.com/users/holmja))

## How to contribute
Have an idea? Found a bug? See [how to contribute][contributing].

## Where is this library used?
If you are using this library in one of your projects, add it in this list. :sparkles:

 - [`cobol-promises`](https://github.com/IonicaBizau/node-cobol-promises)

## License

[MIT][license] © [Ionică Bizău][website]

[paypal-donations]: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RVXDDLKKLQRJW
[donate-now]: http://i.imgur.com/6cMbHOC.png

[license]: http://showalicense.com/?fullname=Ionic%C4%83%20Biz%C4%83u%20%3Cbizauionica%40gmail.com%3E%20(http%3A%2F%2Fionicabizau.net)&year=2013#license-mit
[website]: http://ionicabizau.net
[contributing]: /CONTRIBUTING.md
[docs]: /DOCUMENTATION.md