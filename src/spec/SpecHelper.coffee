exec = require('child_process').exec

module.exports =

  execCommand: (options, callback)->
    exec "#{__dirname}/../bin/sphere #{options}", (err, stdout)-> callback(err, stdout)

  runCommand: (command, argv, method, callback)->
    spyOn(command.program, 'executeSubCommand')
    spyOn(command.program, 'parse').andCallThrough()
    spyOn(command, method)
    command.run argv
    callback(command)
