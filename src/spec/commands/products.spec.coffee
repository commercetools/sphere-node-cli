process.env.NODE_ENV = 'test'

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

  it "$ sphere products list", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'list']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({})
      done()

  it "$ sphere products list -j", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'list', '-j']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({jsonPretty: true})
      done()

  it "$ sphere products get 123", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'get', '123']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({id: '123'})
      done()

  it "$ sphere products get 123 -j", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'get', '123', '-j']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({id: '123', jsonPretty: true})
      done()

  it "$ sphere products get 123 -p", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'get', '123', '-p']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({id: '123', isProjection: true})
      done()

  it "$ sphere products get 123 -j -p", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'get', '123', '-j', '-p']
    SpecHelper.runCommand @command, ARGV, '_get', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._get).toHaveBeenCalledWith({id: '123', jsonPretty: true, isProjection: true})
      done()

  it "$ sphere products create", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'create']
    SpecHelper.runCommand @command, ARGV, '_create', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._create).toHaveBeenCalledWith({})
      done()
