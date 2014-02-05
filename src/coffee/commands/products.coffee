ClientUtils = require('../utils/client')

module.exports = class

  ###*
   * Expose `Command` object in order to spy on it
  ###
  @program: require('commander')

  ###*
   * `sphere-products` entry point
   * @param {Object} argv Parsed command line options
  ###
  @run: (argv)=>

    @program
      .option('-J, --json-raw', 'output in raw JSON (default)')
      .option('-j, --json-pretty', 'output in pretty-printed JSON')
      .option('-p, --projection', 'return a projection of the product')

    @program
      .command('list')
      .description('Query the full representations of products')
      .action => @_get
        isProjection: @program.projection
        jsonPretty: @program.jsonPretty

    @program
      .command('get <id>')
      .description('Get the full representation of a product by ID')
      .action (id)=> @_get
        id: id
        isProjection: @program.projection
        jsonPretty: @program.jsonPretty

    @program
      .command('create')
      .description('Create a new product')
      .action => @_create {}

    @program.parse(argv)
    @program.help() unless @program.args.length


  @_get: (opts = {})-> ClientUtils.fetch 'products', opts

  @_create: (opts = {})-> ClientUtils.create()
