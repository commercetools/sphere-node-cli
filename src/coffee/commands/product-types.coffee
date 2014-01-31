program = require('commander')
SphereClient = require('sphere-node-client')
ClientUtils  = require('../utils/client')

program
  .option('-J, --json-raw', 'output in raw JSON (default)')
  .option('-j, --json-pretty', 'output in pretty-printed JSON')

program
  .command('list')
  .description('List product types')
  .action -> ClientUtils.fetch 'productTypes',
    jsonPretty: program.jsonPretty

program
  .command('create')
  .description('Create a new product type')
  .action -> ClientUtils.create()

program.parse(process.argv)

program.help() unless program.args.length
