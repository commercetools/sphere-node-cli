should = require 'should'
BIN_DIR = "#{__dirname}/../../bin"

describe 'sphere-import', ->

  beforeEach ->
    @command = require '../../src/commands/import'
    @command.program = require('rewire')('commander')
    @command.run(['node', "#{BIN_DIR}/sphere-import"])

  it 'should print command', ->
    @command.program.name.should.be.a.Function;
    @command.program.name().should.equal('sphere-import')
    # console.log @command.program.options
    @command.program.commands.should.have.lengthOf(0)
