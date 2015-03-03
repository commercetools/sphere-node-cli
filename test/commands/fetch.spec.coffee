_ = require 'underscore'
should = require 'should'
FetchCommand = require '../../src/commands/fetch'
BIN_DIR = "#{__dirname}/../../bin"

FAKE_CREDENTIALS =
  project_key: 'foo'
  client_id: '123'
  client_secret: 'abc'

describe 'FetchCommand', ->

  beforeEach ->
    @command = new FetchCommand
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    spyOn(@command, '_validateOptions').and.callThrough()
    spyOn(@command, '_die')
    spyOn(@command, '_preProcess') # just to stub it
    @command.run(['node', "#{BIN_DIR}/sphere-fetch"])
    @command.program.name.should.be.a.Function
    @command.program.name().should.equal('sphere-fetch')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options.should.have.lengthOf(2)
    @command.program.options[0].flags.should.equal('-p, --project <key>')
    @command.program.options[1].flags.should.equal('-t, --type <name>')
    @command.program.should.not.have.property('project')
    @command.program.should.not.have.property('type')
    expect(@command._validateOptions).toHaveBeenCalledWith({}, 'type')
    expect(@command._die).toHaveBeenCalledWith('Missing required options: type')

  it 'should process command', ->
    spyOn(@command, '_fetch')
    spyOn(@command, '_process').and.callThrough()
    spyOn(@command, '_preProcess').and.callFake (opts) =>
      @command._process _.extend opts, {credentials: FAKE_CREDENTIALS}
    @command.run(['node', "#{BIN_DIR}/sphere-fetch", '-p', 'foo', '-t', 'products'])
    @command.program.project.should.be.equal('foo')
    @command.program.type.should.be.equal('products')
    expect(@command._preProcess).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()

