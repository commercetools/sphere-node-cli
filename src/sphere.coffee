debug = require('debug')('sphere')
program = require 'commander'
pkg = require '../package.json'

program
  .version(pkg.version)

program
  .command('import', 'Import resources')

module.exports =

  run: (argv) ->
    debug 'parsing args: %s', argv

    program.parse(argv)
    program.help() unless program.args.length
