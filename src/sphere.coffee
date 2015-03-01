debug = require('debug')('sphere')
pkg = require '../package.json'
{ENV} = require './utils/env'
help = require './utils/help'

module.exports = class

  @program: require 'commander'

  @run: (argv) =>
    debug 'parsing args: %s', argv

    @program
      .version(pkg.version)
      .command 'import', 'Import resources'
      .on '--help', help
      .parse(argv)

    if ENV isnt 'test' and not @program.args.length
      @program.help()
