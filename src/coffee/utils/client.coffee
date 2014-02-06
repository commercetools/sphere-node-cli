SphereClient = require('sphere-node-client')
AuthUtils = require('./auth')
{ log, logError } = require('../common')

###*
 * Utils for using 'SphereClient'
###
module.exports = class

  @fetch: (serviceName, opts = {})->
    AuthUtils.exist (data)->
      { id, jsonPretty, where, whereOperator, page, perPage } = opts

      client = new SphereClient config: data
      service = client[serviceName]
      service = service.byId(id) if id

      service
      .where(where)
      .whereOperator(whereOperator)
      .page(page)
      .perPage(perPage)
      .fetch().then (result)->
        # TODO: use helper to handle all responses
        if opts.jsonPretty
          log JSON.stringify result, null, 4
        else
          log JSON.stringify result
      .fail (e)-> logError e

  @create: -> log "Coming soon"
