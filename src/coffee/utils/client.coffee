nconf   = require('../helper').nconf
SphereClient = require('sphere-node-client')


###*
 * Utils for using 'SphereClient'
###

exports.fetch = (serviceName, opts = {})->
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

exports.create = ->
  console.log "Coming soon"
