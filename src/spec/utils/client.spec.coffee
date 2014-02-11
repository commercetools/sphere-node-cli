_ = require('underscore')._
SphereClient = require('sphere-node-client')
ClientUtils = require('../../lib/utils/client')

describe 'ClientUtils', ->

  beforeEach ->
    @mockClient = new SphereClient
      config:
        client_id: 'my-id'
        client_secret: 'secret'
        project_key: 'foo'
    spyOn(@mockClient._rest, 'GET').andCallFake (endpoint, callback)-> callback(null, {statusCode: 200}, {foo: 'bar'})
    spyOn(ClientUtils, 'client').andCallFake (data)=> @mockClient

  it 'should fetch', (done)->
    ClientUtils.fetch 'products', {}, (result)->
      console.log result
      expect(result).toEqual foo: 'bar'
      done()
