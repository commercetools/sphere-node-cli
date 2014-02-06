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
      .option('-w, --where <predicate>', 'define a query predicate')
      .option('-o, --where-operator <operator>', 'define the logical operator
        to combine multiple where parameters (default is and)')
      .option('-n, --page <n>', 'define the page number to be requested
        from the query result (default is 1)', parseInt)
      .option('-t, --per-page <n>', 'define the number of results to return
        from the query (default is 100). If set to 0 all results
        are returned', parseInt)

    @program
      .command('list')
      .description('Query the full representations of products')
      .action => @_get
        isProjection: @program.projection
        jsonPretty: @program.jsonPretty
        where: @program.where
        whereOperator: @program.whereOperator
        page: @program.page
        perPage: @program.perPage

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


  @_get: (opts = {})->
    if opts.isProjection
      ClientUtils.fetch 'productProjections', opts
    else
      ClientUtils.fetch 'products', opts

  @_create: (opts = {})-> ClientUtils.create()
