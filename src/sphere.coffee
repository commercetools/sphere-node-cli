debug = require('debug')('sphere')
pkg = require '../package.json'
{ENV} = require './utils/env'

module.exports = class

  @program: require 'commander'

  @run: (argv) =>
    debug 'parsing args: %s', argv

    @program
      .version(pkg.version)
      .command('import', 'Import resources')
      .parse(argv)

    if ENV isnt 'test' and not @program.args.length
      @program.help()
