fs      = require('fs')
prompt  = require('prompt')
nconf   = require('../helper').nconf
helper  = require('../helper')
common  = require('../common')
{ log, logError } = common

###*
 * Utils for 'Auth' command
###

module.exports = class

  @save: ->
    prompt.start()
    prompt.get ['client_id', 'client_secret', 'project_key'], (error, result)->
      return error '' if error
      nconf.set 'client_id', result.client_id
      nconf.set 'client_secret', result.client_secret
      nconf.set 'project_key', result.project_key

      _save = ->
        nconf.save (e)->
          return e if e
          log 'Credentials saved!'
          nconf.load (e, data)->
            return e if e
            log helper.PATH_TO_CREDENTIALS
            log data

      # check if path exist
      if fs.existsSync helper.ROOT_FOLDER
        _save()
      else
        # create dir
        fs.mkdir helper.ROOT_FOLDER, (e)->
          return e if e
          _save()

  @show: ->
    nconf.load (e, data)->
      return e if e
      log data

  @clean: ->
    logError 'Not implemented yet'

  @exist: (cb)->
    nconf.load (e, data)->
      # TODO: prompt for credentials, if not found
      return logError 'Credentials not found' if e
      cb(data)
