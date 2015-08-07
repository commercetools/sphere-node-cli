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

  it 'should load credentials and call _process', (done) ->
    # we need to inject the `credentials` dependency in order to mock it
    # (we don't want to actually read real credentials)
    BaseCommandStub = require('rewire')('../../src/utils/command')
    BaseCommandStub.__set__ 'credentials',
      load: (projectKey) -> Promise.resolve {project_key: projectKey}

    command = new BaseCommandStub
    # we manually create a spy (`spyOn(command, '_process')` doesn't seem to work!)
    command._process = jasmine.createSpy('process')
    command._preProcess({foo: 'bar', project: 'test'})

    checkCall = ->
      if command._process.calls.count() is 1
        expect(command._process).toHaveBeenCalledWith
          foo: 'bar'
          project: 'test'
          config: {}
          credentials:
            project_key: 'test'
        clearInterval(interval)
        done()

    # since _preProcess executes a promise we need to check
    # the call in a async way
    # (haven't found a better way to do it)
    interval = setInterval(checkCall, 100)

  it 'should parse config', (done) ->
    @command._parseConfig(JSON.stringify({foo: 'bar'}))
    .then (config) ->
      expect(config).toEqual {foo: 'bar'}
      done()
    .catch done

  it 'should resolve if config option is not provided', (done) ->
    @command._parseConfig()
    .then (config) ->
      expect(config).toEqual {}
      done()
    .catch done

  it 'should throw if config cannot be parsed', ->
    spyOn(@command, '_die')
    @command._parseConfig('foo=bar')
    expect(@command._die).toHaveBeenCalledWith 'Cannot parse config', jasmine.any(Object)
