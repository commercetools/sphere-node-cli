fs      = require('fs')
prompt  = require('prompt')
nconf   = require('../helper').nconf
helper  = require('../helper')

###*
 * Utils for 'Auth' command
###

module.exports =

  saveCredentials: ->
    prompt.start()
    prompt.get ['client_id', 'client_secret', 'project_key'], (error, result)->
      return console.log '' if error
      nconf.set 'client_id', result.client_id
      nconf.set 'client_secret', result.client_secret
      nconf.set 'project_key', result.project_key

      save = ->
        nconf.save (e)->
          return e if e
          console.log 'Credentials saved!'
          nconf.load (e, data)->
            return e if e
            console.log helper.PATH_TO_CREDENTIALS
            console.log data

      # check if path exist
      if fs.existsSync helper.ROOT_FOLDER
        save()
      else
        # create dir
        fs.mkdir helper.ROOT_FOLDER, (e)->
          return e if e
          save()

  loadCredentials: ->
    nconf.load (e, data)->
      return e if e
      console.log data
