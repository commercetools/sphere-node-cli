_ = require 'underscore'
should = require 'should'
ExportCommand = require '../../src/commands/export'
BIN_DIR = "#{__dirname}/../../bin"

FAKE_CREDENTIALS =
  project_key: 'foo'
  client_id: '123'
  client_secret: 'abc'

describe 'ExportCommand', ->

  beforeEach ->
    @command = new ExportCommand
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    spyOn(@command, '_validateOptions').and.callThrough()
    spyOn(@command, '_die')
    spyOn(@command, '_preProcess') # just to stub it
    @command.run(['node', "#{BIN_DIR}/sphere-export"])
    @command.program.name.should.be.a.Function
    @command.program.name().should.equal('sphere-export')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options.should.have.lengthOf(4)
    @command.program.options[0].flags.should.equal('-p, --project <key>')
    @command.program.options[1].flags.should.equal('-t, --type <name>')
    @command.program.options[2].flags.should.equal('-o, --output <path>')
    @command.program.options[3].flags.should.equal('--pretty')
    @command.program.should.not.have.property('project')
    @command.program.should.not.have.property('type')
    @command.program.should.not.have.property('output')
    @command.program.should.not.have.property('pretty')
    expect(@command._validateOptions).toHaveBeenCalledWith({}, 'type')
    expect(@command._die).toHaveBeenCalledWith('Missing required options: type')

  it 'should process command', ->
    spyOn(@command, '_stream')
    spyOn(@command, '_process').and.callThrough()
    spyOn(@command, '_preProcess').and.callFake (opts) =>
      @command._process _.extend opts, {credentials: FAKE_CREDENTIALS}
    @command.run(['node', "#{BIN_DIR}/sphere-export", '-p', 'foo', '-t', 'product', '-o', './export.json'])
    @command.program.project.should.be.equal('foo')
    @command.program.type.should.be.equal('product')
    @command.program.output.should.be.equal('./export.json')
    expect(@command._preProcess).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()
    expect(@command._stream).toHaveBeenCalledWith
      project: 'foo'
      type: 'product'
      output: './export.json'
      credentials: FAKE_CREDENTIALS
    , jasmine.any(Function), jasmine.any(Function)
