SphereClient = require('sphere-node-client')
nconf = require('../helper').nconf

###*
 * Utils for using 'SphereClient'
###
module.exports =

  fetch: (serviceName, opts = {})->
    nconf.load (e, data)->
      return e if e
      client = new SphereClient config: data
      service = client[serviceName]
      service = service.byId(opts.id) if opts.id
      service.fetch().then (result)->
        if opts.jsonPretty
          console.log JSON.stringify result, null, 4
        else
          console.log JSON.stringify result

  create: ->
    console.log "Coming soon"
