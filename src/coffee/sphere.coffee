pkg = require('../package.json')
program = require('commander')
{ log } = require('./common')

program
  .version(pkg.version)

program
  .command('auth', 'Provide credentials for authentication')
  .command('products', 'Manage products for a project')
  .command('product-types', 'Manage product types for a project')

program.on '--help', ->
  log ''
  log '    __  __      __  __  __     __'
  log '   /_  /_/ /_/ /_  /_/ /_   / /  /'
  log '  __/ /   / / /_  / \\ /_ . / /__/'
  log ''

module.exports =

  run: (argv)->
    program.parse(argv)
    program.help() unless program.args.length
