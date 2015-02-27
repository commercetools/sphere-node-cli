fs = require 'fs'
DEFAULT_PATH = "#{__dirname}/../../sphere-credentials.json"

module.exports =

  validate: (path) ->
    path = DEFAULT_PATH unless path

    try
      fs.readFileSync path, {encoding: 'utf-8'}
      return true
    catch e
      return false

  load: (path) ->
    path = DEFAULT_PATH unless path

    c = fs.readFileSync path, {encoding: 'utf-8'}
    JSON.parse(c)
