program = require('commander')
prompt = require('prompt')

program.parse(process.argv)

prompt.start()
prompt.get ['client_id', 'client_secret', 'project_key'], (error, result)->
  console.log 'Options received'
  console.log "Client ID: #{result.client_id}"
  console.log "Client SECRET: #{result.client_secret}"
  console.log "Project Key: #{result.project_key}"
