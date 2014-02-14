_  = require('underscore')._
fs = require 'fs'
AuthUtils = require '../../lib/utils/auth'
common    = require '../../lib/common'
helper    = require '../../lib/helper'
{ nconf } = require '../../lib/helper'

describe 'AuthUtils (mocked)', ->

  beforeEach ->
    spyOn(common, 'log')
    spyOn(AuthUtils, 'prompt').andCallFake (callback) ->
      callback(null, {client_id: 'foo', client_secret: 'bar', project_key: 'test'})
    spyOn(fs, 'existsSync').andReturn true
    spyOn(nconf, 'save').andCallFake (callback) -> callback(null)
    spyOn(nconf, 'load').andCallFake (callback) ->
      callback(null, {client_id: 'foo', client_secret: 'bar', project_key: 'test'})

  it 'should save credentials', ->
    AuthUtils.save()
    expect(AuthUtils.prompt).toHaveBeenCalledWith(jasmine.any(Function))
    expect(nconf.save).toHaveBeenCalled()
    expect(nconf.load).toHaveBeenCalled()

  it 'should load credentials', ->
    AuthUtils.show()
    expect(nconf.load).toHaveBeenCalled()

describe 'AuthUtils', ->

  beforeEach ->
    spyOn(common, 'log')
    spyOn(AuthUtils, 'prompt').andCallFake (callback) ->
      callback(null, {client_id: 'foo', client_secret: 'bar', project_key: 'test'})

  it 'should write credentials to file', (done) ->
    AuthUtils.save (data) ->
      expect(data).toEqual {client_id: 'foo', client_secret: 'bar', project_key: 'test'}
      done()

  it 'should read credentials from file', (done) ->
    AuthUtils.show (data) ->
      expect(data).toEqual {client_id: 'foo', client_secret: 'bar', project_key: 'test'}
      done()
