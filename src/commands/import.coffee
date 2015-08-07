debug = require('debug')('sphere-import')
fs = require 'fs'
_ = require 'underscore'
___ = require 'highland'
transform = require 'stream-transform'
JSONStream = require 'JSONStream'
StockImport = require 'sphere-stock-import'
{ProductImport, PriceImport} = require 'sphere-product-import'
BaseCommand = require '../utils/command'
log = require '../utils/logger'
{USER_AGENT} = require '../utils/env'

module.exports = class extends BaseCommand

  run: (argv) ->
    debug 'parsing args: %s', argv

    @program
      .option '-p, --project <key>', 'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)'
      .option '-t, --type <name>', 'type of import'
      .option '-f, --from <path>', 'the path to a JSON file where to read from'
      .option '-b, --batch <n>', 'how many chunks should be processed in batches (default: 5)', parseInt, 5
      .option '-c, --config <object>', 'a JSON object as a string to be passed to the related library, ' +
        'usually containing specific configuration options'

    @program.parse(argv)
    options = _.pick(@program, 'project', 'type', 'from', 'batch', 'config')
    @_validateOptions(options, 'type')
    @_preProcess(options)

  _process: (options) ->
    switch options.type
      when 'stock'
        service = new StockImport null,
          config: options.credentials
          user_agent: USER_AGENT
        processFn = _.bind(service.performStream, service)
        finishFn = -> log.info service.summaryReport(options.from)
        @_stream(options, 'stocks.*', processFn, finishFn)
      when 'product'
        service = new ProductImport log, _.extend({}, options.config,
          clientConfig:
            config: options.credentials
            user_agent: USER_AGENT)
        processFn = _.bind(service.performStream, service)
        finishFn = -> log.info service.summaryReport(options.from)
        @_stream(options, 'products.*', processFn, finishFn)
      when 'price'
        service = new PriceImport log, _.extend({}, options.config,
          clientConfig:
            config: options.credentials
            user_agent: USER_AGENT)
        processFn = _.bind(service.performStream, service)
        finishFn = -> log.info service.summaryReport(options.from)
        @_stream(options, 'prices.*', processFn, finishFn)
      else
        @_die "Unsupported type: #{type}"

  _stream: (options, jsonPath, processFn, finishFn) ->
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
      process.stdout.write('.')
      processFn(chunk, cb)
    , {parallel: 1}) # we want to process one chunk at a time (chunk size is determined by batch value)

    # this trick allows to accumulate the stream to a single value ()
    # so that when we pull the value after that we know that all chunks have been processed
    # and we can display a final message
    ___(transformStream).reduce null, -> ''
    .stopOnError (e) => @_die 'Something went wrong while transforming chunks.\n', e
    .pull (err, x) ->
      if err then log.error err
      else finishFn()
