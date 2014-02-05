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

  @prompt: (callback)->
    prompt.start()
    prompt.message = ''
    prompt.delimiter = ''
    prompt.colors = false
    prompt.get [
        name: 'client_id'
        required: true
      ,
        name: 'client_secret'
        required: true
      ,
        name: 'project_key'
        required: true
    ], (error, result)->
      callback(error, result)

  @save: ->
    @prompt (error, result)->
      return logError error if error
      nconf.set 'client_id', result.client_id
      nconf.set 'client_secret', result.client_secret
      nconf.set 'project_key', result.project_key

      _save = ->
        nconf.save (e)->
          return logError e if e
          log 'Credentials saved!'
          nconf.load (e, data)->
            return logError e if e
            log helper.PATH_TO_CREDENTIALS
            log data

      # check if path exist
      if fs.existsSync helper.ROOT_FOLDER
        _save()
      else
        # create dir
        fs.mkdir helper.ROOT_FOLDER, (e)->
          return logError e if e
          _save()

  @show: ->
    nconf.load (e, data)->
      return logError e if e
      log data

  @clean: ->
    logError 'Not implemented yet'

  @exist: (cb)->
    nconf.load (e, data)->
      # TODO: prompt for credentials, if not found
      return logError 'Credentials not found' if e
      cb(data)
