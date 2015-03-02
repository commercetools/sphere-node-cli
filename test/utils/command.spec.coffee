_ = require 'underscore'
Promise = require 'bluebird'
BaseCommand = require '../../src/utils/command'
ROOT_DIR = "#{__dirname}/../.."

FAKE_CREDENTIALS =
  project_key: 'foo'
  client_id: '123'
  client_secret: 'abc'

describe 'BaseCommand', ->

  beforeEach ->
    @command = new BaseCommand

  it 'should throw when calling run (no implementation in base class)', ->
    expect(=> @command.run()).toThrow(new Error 'Base run method must be overridden')

  it 'should throw when calling _process (no implementation in base class)', ->
    expect(=> @command._process()).toThrow(new Error 'Base _process method must be overridden')

  it 'should validate options', ->
    spyOn(@command, '_die')
    @command._validateOptions
      foo: 'bar'
    , 'type'
    expect(@command._die).toHaveBeenCalledWith 'Missing required options: type'

  it 'should load credentials and call _process', ->
    # we need to inject the `credentials` dependency in order to mock it
    # (we don't want to actually read real credentials)
    BaseCommandStub = require('rewire')('../../src/utils/command')
    BaseCommandStub.__set__ 'credentials',
      load: (projectKey) -> Promise.resolve {project_key: projectKey}

    command = new BaseCommandStub
    # we manually create a spy (`spyOn(command, '_process')` doesn't seem to work!)
    command._process = jasmine.createSpy('process')

    # now the fun part:
    # - we first execute the method that reads the credentials
    # - the credentials are mocked and a promise is returned
    # - then we wait for our spied function to be called (async workflow)
    # - finally we check that the spy was correctly called
    runs -> command._preProcess({foo: 'bar', project: 'test'})
    waitsFor -> command._process.calls.length is 1
    runs ->
      expect(command._process).toHaveBeenCalledWith
        foo: 'bar'
        project: 'test'
        credentials:
          project_key: 'test'
