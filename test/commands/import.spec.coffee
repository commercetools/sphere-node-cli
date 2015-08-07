_ = require 'underscore'
should = require 'should'
ImportCommand = require '../../src/commands/import'
BIN_DIR = "#{__dirname}/../../bin"

FAKE_CREDENTIALS =
  project_key: 'foo'
  client_id: '123'
  client_secret: 'abc'

describe 'ImportCommand', ->

  beforeEach ->
    @command = new ImportCommand
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    spyOn(@command, '_validateOptions').and.callThrough()
    spyOn(@command, '_die')
    spyOn(@command, '_preProcess') # just to stub it
    @command.run(['node', "#{BIN_DIR}/sphere-import"])
    @command.program.name.should.be.a.Function
    @command.program.name().should.equal('sphere-import')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options.should.have.lengthOf(5)
    @command.program.options[0].flags.should.equal('-p, --project <key>')
    @command.program.options[1].flags.should.equal('-t, --type <name>')
    @command.program.options[2].flags.should.equal('-f, --from <path>')
    @command.program.options[3].flags.should.equal('-b, --batch <n>')
    @command.program.options[4].flags.should.equal('-c, --config <object>')
    @command.program.should.not.have.property('project')
    @command.program.should.not.have.property('type')
    @command.program.should.not.have.property('from')
    @command.program.should.not.have.property('config')
    @command.program.should.have.property('batch')
    expect(@command._validateOptions).toHaveBeenCalledWith({ batch: 5 }, 'type')
    expect(@command._die).toHaveBeenCalledWith('Missing required options: type')

  it 'should process stock command', ->
    spyOn(@command, '_stream')
    spyOn(@command, '_process').and.callThrough()
    spyOn(@command, '_preProcess').and.callFake (opts) =>
      @command._process _.extend opts, {config: {}, credentials: FAKE_CREDENTIALS}
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-p', 'foo', '-t', 'stock', '-f', './foo.json'])
    @command.program.project.should.be.equal('foo')
    @command.program.type.should.be.equal('stock')
    @command.program.from.should.be.equal('./foo.json')
    expect(@command._preProcess).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()
    expect(@command._stream).toHaveBeenCalledWith
      project: 'foo'
      type: 'stock'
      from: './foo.json'
      batch: 5
      config: {}
      credentials: FAKE_CREDENTIALS
    , 'stocks.*', jasmine.any(Function), jasmine.any(Function)

  it 'should process product command', ->
    spyOn(@command, '_stream')
    spyOn(@command, '_process').and.callThrough()
    spyOn(@command, '_preProcess').and.callFake (opts) =>
      @command._process _.extend opts, {config: {}, credentials: FAKE_CREDENTIALS}
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-p', 'foo', '-t', 'product', '-f', './foo.json'])
    @command.program.project.should.be.equal('foo')
    @command.program.type.should.be.equal('product')
    @command.program.from.should.be.equal('./foo.json')
    expect(@command._preProcess).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()
    expect(@command._stream).toHaveBeenCalledWith
      project: 'foo'
      type: 'product'
      from: './foo.json'
      batch: 5
      config: {}
      credentials: FAKE_CREDENTIALS
    , 'products.*', jasmine.any(Function), jasmine.any(Function)

  it 'should process price command', ->
    spyOn(@command, '_stream')
    spyOn(@command, '_process').and.callThrough()
    spyOn(@command, '_preProcess').and.callFake (opts) =>
      @command._process _.extend opts, {config: {}, credentials: FAKE_CREDENTIALS}
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-p', 'foo', '-t', 'price', '-f', './foo.json'])
    @command.program.project.should.be.equal('foo')
    @command.program.type.should.be.equal('price')
    @command.program.from.should.be.equal('./foo.json')
    expect(@command._preProcess).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()
    expect(@command._stream).toHaveBeenCalledWith
      project: 'foo'
      type: 'price'
      from: './foo.json'
      batch: 5
      config: {}
      credentials: FAKE_CREDENTIALS
    , 'prices.*', jasmine.any(Function), jasmine.any(Function)
