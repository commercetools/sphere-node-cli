debug = require('debug')('sphere-import')
fs = require 'fs'
_ = require 'highland'
transform = require 'stream-transform'
JSONStream = require 'JSONStream'
StockImport = require '../services/stock-import'
log = require '../utils/logger'

module.exports = class

  @program: require 'commander'

  @run: (argv) =>
    debug 'parsing args: %s', argv

    @program
      .option '-t, --type <name>', 'type of import'
      .option '-f, --from <path>', 'the source to read'

    @program.parse(argv)
    @_validateOptions(@program)

    @_process(@program.type, @program.from)

  @_validateOptions: (options) ->
    errors = []
    errors.push('Missing required option: type') unless options.type

    if errors.length > 0
      errors.forEach (e) -> log.error(e)
      process.exit(1)

  @_process: (type, from) =>
    switch type
      when 'stock' then @_processStock(from)
      else
        throw new Error "Unsupported type: #{type}"

  @_processStock: (from) ->
    service = new StockImport(log, {})

    inputStream = if from
      fs.createReadStream(from, {encoding: 'utf-8'})
    else
      log.info 'Reading data from stdin...'
      process.stdin.resume()
      process.stdin.setEncoding('utf8')
      process.stdin

    # TODO: error handling
    transformStream = _(inputStream.pipe(JSONStream.parse('stocks.*')))
    .batch(5)
    .pipe(transform (chunk, cb) ->
      log.info 'chunk: %j', chunk, {}
      service.process(chunk, cb)
    , {parallel: 1}) # we want to process one chunk at a time (chunk size is determined by batch value)

    # this trick allows to accumulate the stream to a single value ()
    # so that when we pull the value after that we know that all chunks have been processed
    # and we can display a final message
    _(transformStream).reduce null, -> ''
    .pull (err, x) ->
      if err then log.error err
      else log.info service.summaryReport(from)
