process.env.NODE_ENV = 'test'

_ = require('underscore')._
ProductTypesCommand = require('../../lib/commands/product-types')
SpecHelper = require('../SpecHelper')

describe 'Sphere CLI :: sphere-product-types', ->

  beforeEach ->
    @command = new ProductTypesCommand

  afterEach ->
    @command = null

  _.each ['product-types', 'help product-types', 'product-types -h', 'product-types --help'], (cmd)->
    it "$ sphere #{cmd}", (done)->
      SpecHelper.execCommand cmd, (error, result)->
        expect(result).toMatch /Usage\: sphere-product-types \[options\] \[command\]/
        done()

  it "$ sphere product-types list", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-product-types", 'list']
    SpecHelper.runCommand @command, ARGV, '_list', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._list).toHaveBeenCalledWith({})
      done()

  it "$ sphere product-types list -j", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-product-types", 'list', '-j']
    SpecHelper.runCommand @command, ARGV, '_list', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._list).toHaveBeenCalledWith({jsonPretty: true})
      done()

  it "$ sphere product-types create", (done)->
    ARGV = ['node', "#{__dirname}/../bin/sphere-product-types", 'create']
    SpecHelper.runCommand @command, ARGV, '_create', (_cli)->
      expect(_cli.program.parse).toHaveBeenCalledWith(ARGV)
      expect(_cli._create).toHaveBeenCalledWith({})
      done()
