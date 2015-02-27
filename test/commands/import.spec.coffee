should = require 'should'
BIN_DIR = "#{__dirname}/../../bin"

describe 'sphere-import', ->

  beforeEach ->
    @command = require '../../src/commands/import'
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    spyOn(@command, '_validateOptions').andCallThrough()
    spyOn(@command, '_die')
    spyOn(@command, '_process') # just to stub it
    @command.run(['node', "#{BIN_DIR}/sphere-import"])
    @command.program.name.should.be.a.Function
    @command.program.name().should.equal('sphere-import')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options[0].flags.should.equal('-t, --type <name>')
    @command.program.options[1].flags.should.equal('-f, --from <path>')
    @command.program.should.not.have.property('type')
    @command.program.should.not.have.property('from')
    expect(@command._validateOptions).toHaveBeenCalledWith({batch: 5})
    expect(@command._die).toHaveBeenCalledWith('Missing required options: type')

  it 'should process command', ->
    spyOn(@command, '_process').andCallThrough()
    spyOn(@command, '_stream')
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-t', 'stock', '-f', './foo.json'])
    @command.program.type.should.be.equal('stock')
    @command.program.from.should.be.equal('./foo.json')
    expect(@command._process).toHaveBeenCalled()
    expect(@command._stream).toHaveBeenCalledWith
      type: 'stock'
      from: './foo.json'
      batch: 5
    , jasmine.any(Object), 'stocks.*'
