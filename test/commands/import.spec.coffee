should = require 'should'
BIN_DIR = "#{__dirname}/../../bin"

describe 'sphere-import', ->

  beforeEach ->
    @command = require '../../src/commands/import'
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    spyOn(@command, '_validateOptions')
    spyOn(@command, '_process')
    @command.run(['node', "#{BIN_DIR}/sphere-import"])
    @command.program.name.should.be.a.Function;
    @command.program.name().should.equal('sphere-import')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options[0].flags.should.equal('-t, --type <name>')
    @command.program.options[1].flags.should.equal('-f, --from <path>')
    expect(@command._validateOptions).toHaveBeenCalled()
    expect(@command._process).toHaveBeenCalled()

  it 'should process command', ->
    spyOn(@command, '_process').andCallThrough()
    spyOn(@command, '_processStock')
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-t', 'stock', '-f', './foo.json'])
    @command.program.type.should.be.equal('stock')
    @command.program.from.should.be.equal('./foo.json')
    expect(@command._process).toHaveBeenCalled()
    expect(@command._processStock).toHaveBeenCalled()
