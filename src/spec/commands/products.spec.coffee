_ = require('underscore')._
rewire = require("rewire")
SpecHelper = require('../SpecHelper')

describe 'Sphere CLI :: sphere-products', ->

  beforeEach ->
    @command = require('../../lib/commands/products')
    @command.program = rewire('commander') # returns a new instance of `commander` and inject it

  _.each ['products', 'help products', 'products -h', 'products --help'], (cmd)->
    it "$ sphere #{cmd}", (done)->
      SpecHelper.execCommand cmd, (error, result)->
        expect(result).toMatch /Usage\: sphere-products \[options\] \[command\]/
        done()

  _.each [
    {commands: ['list'], result: {}}
    {commands: ['list', '-j'], result: {jsonPretty: true}}
    {commands: ['get', '123'], result: {id: '123'}}
    {commands: ['get', '123', '-j'], result: {id: '123', jsonPretty: true}}
    {commands: ['get', '123', '-p'], result: {id: '123', isProjection: true}}
    {commands: ['get', '123', '-j', '-p'], result: {id: '123', jsonPretty: true, isProjection: true}}
    {commands: ['list', '-p', '--per-page', '2', '-w', 'name(en=\"Foo\")'], result: {isProjection: true, where: 'name(en="Foo")', perPage: 2}}
  ], (cmd)->
    it "$ sphere products #{cmd.commands.join(' ')}", (done)->
      ARGV = _.union ['node', "#{__dirname}/../bin/sphere-products"], cmd.commands
      SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
        expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
        expect(_cli._get).toHaveBeenCalledWith(cmd.result)
        done()

  it "$ sphere products create", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'create']
    SpecHelper.runCommand @command, ARGV, '_create', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._create).toHaveBeenCalledWith({})
      done()
