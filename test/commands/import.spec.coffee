should = require 'should'
BIN_DIR = "#{__dirname}/../../bin"

describe 'sphere-import', ->

  beforeEach ->
    @command = require '../../src/commands/import'
    @command.program = require('rewire')('commander')

  it 'should initialize command', ->
    @command.run(['node', "#{BIN_DIR}/sphere-import"])
    @command.program.name.should.be.a.Function;
    @command.program.name().should.equal('sphere-import')
    @command.program.commands.should.have.lengthOf(0)
    @command.program.options[0].flags.should.equal('-t, --type <name>')
    @command.program.options[1].flags.should.equal('-f, --from <path>')

  it 'should print command', ->
    @command.run(['node', "#{BIN_DIR}/sphere-import", '-t', 'stock', '-f', './foo.json'])
    @command.program.type.should.be.equal('stock')
    @command.program.from.should.be.equal('./foo.json')
