debug = require('debug')('sphere-import')
fs = require 'fs'
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
      log.info('Reading data from stdin...')
      process.stdin.resume()
      process.stdin.setEncoding('utf8')
      process.stdin

    inputStream
    .pipe(JSONStream.parse('stocks.*'))
    .on 'error', (e) -> log.error 'error while parsing JSON chunks: %j', e
    .pipe(transform (record, cb) ->
      log.info 'record: %j', record, {}
      service.process(record, cb)
    , {parallel: 1})
    .on 'error', (e) -> log.error 'error while processing stocks: %j', e
    .pipe(transform (record, cb) ->
      log.info(record)
      cb()
    )
