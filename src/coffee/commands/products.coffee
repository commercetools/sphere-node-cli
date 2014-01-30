program = require('commander')

getProducts = ->
  console.log "Getting products"

createProduct = ->
  console.log "Creating product"

program
  .option('-p, --project=key', 'project key to use')

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
