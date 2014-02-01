AuthUtils = require('../utils/auth')

class AuthCommand

  constructor: ->
    ###*
     * Expose `Command` object in order to spy on it
    ###
    @program = require('commander')

  ###*
   * `sphere-auth` entry point
   * @param {Object} argv Parsed command line options
  ###
  run: (argv)->

    @program
      .command('save')
      .description('Save auth credentials locally')
      .action => @_save()

    @program
      .command('load')
      .description('Load auth credentials')
      .action => @_load()

    @program.parse(argv)
    @program.help() unless @program.args.length


  _save: -> AuthUtils.saveCredentials()

  _load: -> AuthUtils.loadCredentials()


module.exports = AuthCommand
