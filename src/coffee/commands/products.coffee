program = require('commander')

getProducts = ->
  console.log "Getting products"

createProduct = ->
  console.log "Creating product"

program
  .command('list')
  .option('-p, --project=key', 'project key to use')
  .description('List products')

program
  .command('create')
  .option('-p, --project=key', 'project key to use')
  .description('Create a new product')

program.parse(process.argv)

program.help() unless program.args.length
