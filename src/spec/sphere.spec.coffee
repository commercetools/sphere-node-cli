process.env.NODE_ENV = 'test'

exec = require('child_process').exec

runCommand = (options, callback)->
  exec "#{__dirname}/../bin/sphere #{options}", (err, stdout)-> callback(err, stdout)

describe 'Sphere CLI', ->

  it 'should output help when no options are passed', (done)->
    runCommand '', (error, result)->
      expect(result).toMatch /Usage\: sphere \[options\] \[command\]/
      done()