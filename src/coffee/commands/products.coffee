program = require('commander')
nconf   = require('../helper').nconf
SphereClient = require('sphere-node-client')

getProducts = ->
  nconf.load (e, data)->
    return e if e
    client = new SphereClient config: data
    client.products.fetch().then (result)->
      if program.jsonPretty
        console.log JSON.stringify result, null, 4
      else
        console.log JSON.stringify result

createProduct = ->
  console.log "Creating product"

program
  .option('-J, --json-raw', 'output in raw JSON (default)')
  .option('-j, --json-pretty', 'output in pretty-printed JSON')

program
  .command('list')
  .description('List products')
  .action -> getProducts()

program
  .command('create')
  .description('Create a new product')
  .action -> createProduct()

program.parse(process.argv)

program.help() unless program.args.length
