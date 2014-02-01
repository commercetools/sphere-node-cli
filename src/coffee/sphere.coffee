
class SphereCommand

  constructor: ->
    ###*
     * Expose `Command` object in order to spy on it
    ###
    @program = require('commander')

  ###*
   * CLI entry point
   * @param {Object} argv Parsed command line options
  ###
  run: (argv)->
    console.log ''
    console.log '    __  __      __  __  __     __'
    console.log '   /_  /_/ /_/ /_  /_/ /_   / /  /'
    console.log '  __/ /   / / /_  / \\ /_ . / /__/'
    console.log ''

    @program
      .version('0.0.1')

    @program
      .command('auth', 'Provide credentials for authentication')
      .command('products', 'Manage products for a project')
      .command('product-types', 'Manage product types for a project')

    @program.parse(argv)
    @program.help() unless @program.args.length


module.exports = SphereCommand
