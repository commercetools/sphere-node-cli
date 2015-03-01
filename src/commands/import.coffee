debug = require('debug')('sphere-import')
fs = require 'fs'
_ = require 'underscore'
___ = require 'highland'
transform = require 'stream-transform'
JSONStream = require 'JSONStream'
credentials = require '../utils/credentials'
StockImport = require '../services/stock-import'
log = require '../utils/logger'

module.exports = class

  @program: require 'commander'

  @run: (argv) =>
    debug 'parsing args: %s', argv

    @program
      .option '-p, --project <key>', 'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)'
      .option '-t, --type <name>', 'type of import'
      .option '-f, --from <path>', 'the path to a JSON file where to read from'
      .option '-b, --batch <n>', 'how many chunks should be processed in batches (default: 5)', parseInt, 5

    @program.parse(argv)
    options = _.pick(@program, 'project', 'type', 'from', 'batch')
    @_validateOptions(options)
    @_preProcess(options)

  @_die: ->
    log.error.apply(null, arguments)
    process.exit(1)

  @_validateOptions: (options) ->
    errors = []
    errors.push('type') unless options.type

    if errors.length > 0
      @_die "Missing required options: #{errors.join(', ')}"

  @_preProcess: (options) ->
    credentials.load(options.project)
    .then (credentials) =>
      debug 'loaded credentials: %j', credentials
      @_process(_.extend options, {credentials: credentials})
    .catch (err) => @_die err.message

  @_process: (options) =>
    switch options.type
      when 'stock'
        service = new StockImport options.credentials
        @_stream(options, service, 'stocks.*')
      else
        @_die "Unsupported type: #{type}"

  @_stream: (options, service, jsonPath) ->
    inputStream = if options.from
      fs.createReadStream(options.from, {encoding: 'utf-8'})
    else
      log.info 'Reading data from stdin...'
      process.stdin.resume()
      process.stdin.setEncoding('utf8')
      process.stdin

    transformStream = ___(inputStream.pipe(JSONStream.parse(jsonPath)))
    .stopOnError (e) => @_die 'Cannot parse chunk as JSON.\n', e
    .batch(options.batch)
    .pipe(transform (chunk, cb) ->
      log.info 'chunk: %j', chunk, {}
      service.process(chunk, cb)
    , {parallel: 1}) # we want to process one chunk at a time (chunk size is determined by batch value)

    # this trick allows to accumulate the stream to a single value ()
    # so that when we pull the value after that we know that all chunks have been processed
    # and we can display a final message
    ___(transformStream).reduce null, -> ''
    .stopOnError (e) => @_die 'Something went wrong while transforming chunks', e
    .pull (err, x) ->
      if err then log.error err
      else log.info service.summaryReport(options.from)
