debug = require('debug')('sphere')
pkg = require '../package.json'
{ENV} = require './utils/env'
help = require './utils/help'

module.exports = class

  constructor: ->
    @program = require 'commander'

  run: (argv) ->
    debug 'parsing args: %s', argv

    @program
      .version(pkg.version)
      .command 'import', 'Import resources'
      .command 'fetch', 'Fetch resources'
      .on '--help', help
      .parse(argv)

    if ENV isnt 'test' and not @program.args.length
      @program.help()