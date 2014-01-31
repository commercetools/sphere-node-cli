program = require('commander')
nconf   = require('../helper').nconf
SphereClient = require('sphere-node-client')

getProductTypes = ->
  nconf.load (e, data)->
    return e if e
    client = new SphereClient config: data
    client.productTypes.fetch().then (result)->
      if program.jsonPretty
        console.log JSON.stringify result, null, 4
      else
        console.log JSON.stringify result

createProductType = ->
  console.log "Creating product type"

program
  .option('-J, --json-raw', 'output in raw JSON (default)')
  .option('-j, --json-pretty', 'output in pretty-printed JSON')

program
  .command('list')
  .description('List product types')
  .action -> getProductTypes()

program
  .command('create')
  .description('Create a new product type')
  .action -> createProductType()

program.parse(process.argv)

program.help() unless program.args.length
