_             = require('underscore')._
fs            = require 'fs'
SphereClient  = require 'sphere-node-client'
AuthUtils     = require './auth'
common        = require '../common'
{ log, logError } = common

###*
 * Utils for using 'SphereClient'
###
module.exports = class

  @client: (data) -> new SphereClient config: data

  @fetch: (serviceName, opts = {}, callback) ->
    AuthUtils.exist (data) =>
      { id, jsonPretty, where, whereOperator, page, perPage } = opts

      service = @client(data)[serviceName]
      service = service.byId(id) if id

      service
      .where(where)
      .whereOperator(whereOperator)
      .page(page)
      .perPage(perPage)
      .fetch().then (result) ->
        # TODO: use helper to handle all responses
        if opts.jsonPretty
          log JSON.stringify result, null, 4
        else
          log JSON.stringify result
        callback result if _.isFunction callback
      .fail (e) -> logError e

  @create: (serviceName, opts = {}, callback) ->
    AuthUtils.exist (data) =>
      { path, jsonPretty } = opts

      return logError 'Missing path to JSON file for product creation (use --directory option)' unless path

      try
        jsonProduct = JSON.parse fs.readFileSync path, encoding: 'UTF-8'
      catch
        return logError "Could not parse JSON from file: #{path}"

      service = @client(data)[serviceName]
      service.save(jsonProduct)
      .then (result) ->
        # TODO: use helper to handle all responses
        if opts.jsonPretty
          log JSON.stringify result, null, 4
        else
          log JSON.stringify result
        callback result if _.isFunction callback
      .fail (e) -> logError e
