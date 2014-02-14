_ = require('underscore')._
rewire = require 'rewire'
SpecHelper = require '../SpecHelper'

describe 'Sphere CLI :: sphere-auth', ->

  beforeEach ->
    @command = require('../../lib/commands/auth')
    @command.program = rewire('commander') # returns a new instance of `commander` and inject it

  _.each ['auth', 'help auth', 'auth -h', 'auth --help'], (cmd) ->
    it "$ sphere #{cmd}", (done) ->
      SpecHelper.execCommand cmd, (error, result) ->
        expect(result).toMatch /Usage\: sphere-auth \[options\] \[command\]/
        done()

  it "$ sphere auth save", (done) ->
    ARGV = ['node', "#{__dirname}/../bin/sphere-auth", 'save']
    SpecHelper.runCommand @command, ARGV, '_save', (_cli) ->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._save).toHaveBeenCalled()
      done()

  it "$ sphere auth show", (done) ->
    ARGV = ['node', "#{__dirname}/../bin/sphere-auth", 'show']
    SpecHelper.runCommand @command, ARGV, '_show', (_cli) ->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._show).toHaveBeenCalled()
      done()

  it "$ sphere auth clean", (done) ->
    ARGV = ['node', "#{__dirname}/../bin/sphere-auth", 'clean']
    SpecHelper.runCommand @command, ARGV, '_clean', (_cli) ->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._clean).toHaveBeenCalled()
      done()
