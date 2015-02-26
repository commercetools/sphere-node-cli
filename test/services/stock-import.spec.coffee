_ = require 'underscore'
_.mixin require('underscore-mixins')
Promise = require 'bluebird'
StockImport = require '../../src/services/stock-import.coffee'

describe 'StockImport', ->

  beforeEach ->
    @service = new StockImport

  it 'should initialize service', ->
    expect(@service._client).toBeDefined()
    expect(@service._client.constructor.name).toBe 'SphereClient'
    expect(@service._sync).toBeDefined()
    expect(@service._sync.constructor.name).toBe 'InventorySync'
    expect()

  describe '::summaryReport', ->

    it 'should return a report (nothing to do)', ->
      expect(@service.summaryReport('./foo.json')).toEqual 'Summary: nothing to do, everything is fine'

    it 'should return a report (with updates)', ->
      @service._summary =
        emptySKU: 2
        created: 5
        updated: 10
      message = 'Summary: there were 15 imported stocks (5 were new and 10 were updates)' +
       '\nFound 2 empty SKUs from file input \'./foo.json\''
      expect(@service.summaryReport('./foo.json')).toEqual message

  describe '::process', ->

    it 'should process list of stocks and notify when done', (done) ->
      chunk = [
        {sku: 'foo-1', quantityOnStock: 5},
        {sku: 'foo-2', quantityOnStock: 20}
      ]
      existingEntries = [
        {sku: 'foo-1', quantityOnStock: 5},
        {sku: 'foo-2', quantityOnStock: 10}
      ]

      spyOn(@service, '_uniqueStocksBySku').andCallThrough()
      spyOn(@service, '_createOrUpdate').andCallFake -> Promise.all([Promise.resolve({statusCode: 201}), Promise.resolve({statusCode: 200})])
      spyOn(@service._client.inventoryEntries, 'fetch').andCallFake -> new Promise (resolve, reject) -> resolve({body: {results: existingEntries}})

      @service.process chunk, =>
        expect(@service._uniqueStocksBySku).toHaveBeenCalled()
        expect(@service._summary).toEqual
          emptySKU: 0
          created: 1
          updated: 1
        done()


  describe '::_uniqueStocksBySku', ->

    it 'should filter duplicate skus', ->
      stocks = [{sku: 'foo'}, {sku: 'bar'}, {sku: 'baz'}, {sku: 'foo'}]
      uniqueStocks = @service._uniqueStocksBySku(stocks)
      expect(uniqueStocks.length).toBe 3
      expect(_.pluck(uniqueStocks, 'sku')).toEqual ['foo', 'bar', 'baz']


  describe '::_match', ->

    it 'should match correct entry if there is more then one with same SKU', ->
      existingEntries = [
        {
          id: '3da09201-33c8-4b68-8719-6760a94e74b7'
          version: 4
          sku: '22009978'
          supplyChannel:
            typeId: 'channel'
            id: '239772e4-15b4-48d1-b2ad-3ac6e2c3cb21'
          quantityOnStock: 43
          availableQuantity: 43
        },
        {
          id: '4b5b83a2-6da7-45a4-b63d-90adb719ba15'
          version: 9
          sku: '22009978'
          quantityOnStock: 43
          availableQuantity: 43
        }
      ]

      matchingEntry =
        sku: '22009978'
        quantityOnStock: 42

      matchingEntryWithChannel =
        sku: '22009978'
        quantityOnStock: 0
        supplyChannel:
          typeId: 'channel'
          id: '239772e4-15b4-48d1-b2ad-3ac6e2c3cb21'

      expect(@service._match(matchingEntry, existingEntries)).toEqual existingEntries[1]
      expect(@service._match(matchingEntryWithChannel, existingEntries)).toEqual existingEntries[0]

  describe '::_createOrUpdate', ->

    it 'should update and create inventory for same sku', (done) ->
      inventoryEntries = [
        {sku: 'foo', quantityOnStock: 2},
        {sku: 'foo', quantityOnStock: 3, supplyChannel: {typeId: 'channel', id: '111'}}
      ]
      existingEntries = [{id: '123', version: 1, sku: 'foo', quantityOnStock: 1}]

      expectedUpdate =
        version: 1
        actions: [
          {action: 'addQuantity', quantity: 1}
        ]
      expectedCreate =
        sku: 'foo'
        quantityOnStock: 3
        supplyChannel:
          typeId: 'channel'
          id: '111'

      spyOn(@service._client._rest, 'POST').andCallFake (endpoint, payload, callback) ->
        callback(null, {statusCode: 200}, {})

      @service._createOrUpdate inventoryEntries, existingEntries
      .then =>
        # first matched is an update (no channels)
        # second is not a match, so it's a new entry
        expect(@service._client._rest.POST.calls[0].args[1]).toEqual expectedUpdate
        expect(@service._client._rest.POST.calls[1].args[1]).toEqual expectedCreate
        done()
      .catch (err) -> done(_.prettify err)
