debug = require('debug')('service-stock-import')
_ = require 'underscore'
Promise = require 'bluebird'
{SphereClient, InventorySync} = require 'sphere-node-sdk'

module.exports = class

  # TODO:
  # - not sure if we need the logger here
  # - better way to load credentials
  constructor: (@log, opts) ->
    @_sync = new InventorySync
    @_client = new SphereClient require('../../config')

    @_resetSummary()

  _resetSummary: ->
    @_summary =
      emptySKU: 0
      created: 0
      updated: 0

  summaryReport: (filename) ->
    if @_summary.created is 0 and @_summary.updated is 0
      message = 'Summary: nothing to do, everything is fine'
    else
      message = "Summary: there were #{@_summary.created + @_summary.updated} imported stocks " +
        "(#{@_summary.created} were new and #{@_summary.updated} were updates)"

    if @_summary.emptySKU > 0
      warning = "Found #{@_summary.emptySKU} empty SKUs from file input"
      warning += " '#{filename}'" if filename
      @log.warn warning

    message


  process: (stocksToProcess, cb) ->

    ie = @_client.inventoryEntries.all().whereOperator('or')
    debug 'chunk: %j', stocksToProcess
    uniqueStocksToProcessBySku = _.reduce stocksToProcess, (acc, stock) ->
      foundStock = _.find acc, (s) -> s.sku is stock.sku
      acc.push stock unless foundStock
      acc
    , []
    debug 'unique stocks: %j', uniqueStocksToProcessBySku
    _.each uniqueStocksToProcessBySku, (s) =>
      @_summary.emptySKU++ if _.isEmpty s.sku
      # TODO: query also for channel?
      ie.where("sku = \"#{s.sku}\"")
    ie.sort('sku').fetch()
    .then (results) =>
      debug 'Fetched stocks: %j', results
      queriedEntries = results.body.results
      @_createOrUpdate stocksToProcess, queriedEntries
    .then (results) =>
      _.each results, (r) =>
        switch r.statusCode
          when 201 then @_summary.created++
          when 200 then @_summary.updated++
      cb() # IMPORTANT!

  _match: (entry, existingEntries) ->
    _.find existingEntries, (existingEntry) ->
      if entry.sku is existingEntry.sku
        # check channel
        # - if they have the same channel, it's the same entry
        # - if they have different channels or one of them has no channel, it's not
        if _.has(entry, 'supplyChannel') and _.has(existingEntry, 'supplyChannel')
          entry['supplyChannel'].id is existingEntry['supplyChannel'].id
        else
          if _.has(entry, 'supplyChannel') or _.has(existingEntry, 'supplyChannel')
            false # one of them has a channel, the other not
          else
            true # no channel, but same sku
      else
        false

  _createOrUpdate: (inventoryEntries, existingEntries) ->
    debug 'Inventory entries: %j', {toProcess: inventoryEntries, existing: existingEntries}

    posts = _.map inventoryEntries, (entry) =>
      existingEntry = @_match(entry, existingEntries)
      if existingEntry?
        synced = @_sync.buildActions(entry, existingEntry)
        if synced.shouldUpdate()
          @_client.inventoryEntries.byId(synced.getUpdateId()).update(synced.getUpdatePayload())
        else
          Promise.resolve statusCode: 304
      else
        @_client.inventoryEntries.create(entry)

    debug 'About to send %s requests', _.size(posts)
    Promise.all(posts)
