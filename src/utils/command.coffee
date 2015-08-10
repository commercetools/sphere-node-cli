debug = require('debug')('sphere-command')
_ = require 'underscore'
Promise = require 'bluebird'
credentials = require '../utils/credentials'
log = require '../utils/logger'

module.exports = class

  constructor: ->
    @program = require 'commander'

  run: -> throw new Error 'Base run method must be overridden'

  _die: ->
    log.error.apply(null, arguments)
    process.exit(1)

  _validateOptions: (options, types...) ->
    errors = []
    for type in types
      errors.push(type) unless options[type]

    if errors.length > 0
      @_die "Missing required options: #{errors.join(', ')}"

  _preProcess: (options) ->
    credentials.load(options.project)
    .then (credentials) =>
      debug 'loaded credentials: %j', credentials
      @_parseConfig(options.config)
      .then (config) => @_process _.extend(options, { config, credentials })
    .catch (err) => @_die err.message or err

  _parseConfig: (config) ->
    debug 'parsing config: %j', config
    return Promise.resolve({}) unless config

    try
      parsed = JSON.parse(config)
      Promise.resolve(parsed)
    catch e
      @_die 'Cannot parse config', e

  _process: (options) -> throw new Error 'Base _process method must be overridden'
