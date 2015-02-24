debug = require('debug')('sphere-import')

module.exports = class

  @program: require 'commander'

  @run: (argv) =>
    debug 'parsing args: %s', argv

    @program
      .option '-t, --type <name>', 'type of import'
      .option '-f, --from <path>', 'the source to read'
      .parse(argv)

    # TODO:
    # - validate commands
    # - read input (stream)
    console.log('Hey, this is the import command. Given options: (type) %s, (from) %s', @program.type, @program.from)
