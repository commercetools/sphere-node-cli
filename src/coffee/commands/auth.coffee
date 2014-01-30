fs      = require('fs')
program = require('commander')
nconf   = require('nconf')
prompt  = require('prompt')

ROOT = process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE
ROOT_FOLDER = "#{ROOT}/.sphere-cli"
PATH_TO_CREDENTIALS = "#{ROOT_FOLDER}/credentials.json"

nconf.use 'file', file: PATH_TO_CREDENTIALS

saveCredentials = ->
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
          console.log PATH_TO_CREDENTIALS
          console.log data

    # check if path exist
    if fs.existsSync ROOT_FOLDER
      save()
    else
      # create dir
      fs.mkdir ROOT_FOLDER, (e)->
        return e if e
        save()

loadCredentials = ->
  nconf.load (e, data)->
    return e if e
    console.log data

program
  .command('save')
  .description('Save auth credentials locally')
  .action -> saveCredentials()

program
  .command('load')
  .description('Load auth credentials')
  .action -> loadCredentials()

program.parse(process.argv)
program.help() unless program.args.length
