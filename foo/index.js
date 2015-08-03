var Spawn = require("child_process").spawn;

var ps = Spawn('ps');
process.stdin.pipe(ps.stdin);
ps.stdout.pipe(process.stdout);
ps.stderr.pipe(process.stderr);

ps.on("close", function () {
    console.log("Closed");
});
