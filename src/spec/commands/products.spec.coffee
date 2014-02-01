process.env.NODE_ENV = 'test'

_ = require('underscore')._
ProductsCommand = require('../../lib/commands/products')
SpecHelper = require('../SpecHelper')

describe 'Sphere CLI :: sphere-products', ->

  beforeEach ->
    @command = new ProductsCommand

  afterEach ->
    @command = null

  _.each ['products', 'help products', 'products -h', 'products --help'], (cmd)->
    it "$ sphere #{cmd}", (done)->
      SpecHelper.execCommand cmd, (error, result)->
        expect(result).toMatch /Usage\: sphere-products \[options\] \[command\]/
        done()

  it "$ sphere products list", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'list']
    SpecHelper.runCommand @command, ARGV, '_list', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._list).toHaveBeenCalledWith({})
      done()

  it "$ sphere products list -j", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'list', '-j']
    SpecHelper.runCommand @command, ARGV, '_list', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._list).toHaveBeenCalledWith({jsonPretty: true})
      done()

  it "$ sphere products create", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-products", 'create']
    SpecHelper.runCommand @command, ARGV, '_create', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._create).toHaveBeenCalledWith({})
      done()
