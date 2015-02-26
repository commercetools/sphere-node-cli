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
