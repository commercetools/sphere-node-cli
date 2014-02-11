_ = require('underscore')._
SphereClient = require('sphere-node-client')
AuthUtils = require('./auth')
{ log, logError } = require('../common')

###*
 * Utils for using 'SphereClient'
###
module.exports = class

  @client: (data)-> new SphereClient config: data

  @fetch: (serviceName, opts = {}, callback)->
    AuthUtils.exist (data)=>
      { id, jsonPretty, where, whereOperator, page, perPage } = opts

      service = @client(data)[serviceName]
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
        callback result if _.isFunction callback
      .fail (e)-> logError e

  @create: -> log "Coming soon"
