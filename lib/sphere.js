/* ===========================================================
# sphere-node-cli - v0.0.1
# ==============================================================
# Copyright (c) 2014 Nicola Molinari
# Licensed MIT.
*/
var program;

program = require('commander');

program.version('0.0.1').option('-u, --user=email', 'account username').option('-p, --password=pwd', 'account password').option('-j, --json-pretty', 'output in pretty-printed JSON').option('-J, --json-raw', 'output in raw JSON');

program.command('products', 'Manage products for a project');

program.parse(process.argv);

if (!program.args.length) {
  program.help();
}
