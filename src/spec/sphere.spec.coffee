process.env.NODE_ENV = 'test'

_ = require('underscore')._
SpecHelper = require('./SpecHelper')

describe 'Sphere CLI', ->

  _.each ['', 'help', '-h', '--help'], (cmd)->
    it "$ sphere #{cmd}", (done)->
      SpecHelper.execCommand cmd, (error, result)->
        expect(result).toMatch /Usage\: sphere \[options\] \[command\]/
        done()

  _.each ['-V', '--version'], (cmd)->
    it "$ sphere #{cmd}", (done)->
      SpecHelper.execCommand cmd, (error, result)->
        expect(result).toMatch /(\d)\.(\d)\.(\d)/
        done()
