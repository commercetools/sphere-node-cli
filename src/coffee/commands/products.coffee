program = require('commander')
ClientUtils  = require('../utils/client')
SphereClient = require('sphere-node-client')

program
  .option('-J, --json-raw', 'output in raw JSON (default)')
  .option('-j, --json-pretty', 'output in pretty-printed JSON')

program
  .command('list')
  .description('List products')
  .action -> ClientUtils.fetch 'products',
    jsonPretty: program.jsonPretty

program
  .command('create')
  .description('Create a new product')
  .action -> ClientUtils.create()

program.parse(process.argv)

program.help() unless program.args.length
