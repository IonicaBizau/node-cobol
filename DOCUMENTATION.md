## Documentation

You can see below the API reference of this module.

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
 - `remove` (Boolean): Should the compiled executable be removed after running, default is true.
 - `precompiled` (Boolean): Run the precompiled executable instead of re-compiling, default is false.
- **Function** `callback`: The callback function called with `err`, `stdout` and `stderr`.

