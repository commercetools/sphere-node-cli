AuthUtils = require '../utils/auth'

module.exports = class

  ###*
   * Expose `Command` object in order to spy on it
  ###
  @program: require 'commander'

  ###*
   * `sphere-auth` entry point
   * @param {Object} argv Parsed command line options
  ###
  @run: (argv) =>

    @program
      .command('save')
      .description('Save auth credentials locally')
      .action => @_save()

    @program
      .command('show')
      .description('Show current stored authentication credentials')
      .action => @_show()

    @program
      .command('clean')
      .description('Clean the stored authentication credentials')
      .action => @_clean()

    @program.parse(argv)
    @program.help() unless @program.args.length


  @_save: -> AuthUtils.save()

  @_show: -> AuthUtils.show()

  @_clean: -> AuthUtils.clean()
