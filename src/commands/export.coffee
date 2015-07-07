debug = require('debug')('sphere-export')
fs = require 'fs'
_ = require 'underscore'
_.mixin require('underscore.inflection')
{ProductExport} = require 'sphere-product-import'
BaseCommand = require '../utils/command'
log = require '../utils/logger'

module.exports = class extends BaseCommand

  run: (argv) ->
    debug 'parsing args: %s', argv

    @program
      .option '-p, --project <key>', 'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)'
      .option '-t, --type <name>', 'type of export'
      .option '-o, --output <path>', 'the output path where to write the JSON'
      .option '--pretty', 'whether the output JSON should be prettified'

    @program.parse(argv)
    options = _.pick(@program, 'project', 'type', 'output', 'pretty')
    @_validateOptions(options, 'type')
    @_preProcess(options)

  _process: (options) ->
    switch options.type
      when 'product'
        # TODO: make the query configurable
        # - predicate
        service = new ProductExport null,
          config: options.credentials
          user_agent: 'sphere-node-cli'
        processFn = _.bind(service.processStream, service)
        finishFn = -> log.info "Output written to #{options.output}"
        @_stream(options, processFn, finishFn)
      else
        @_die "Unsupported type: #{type}"

  _stream: (options, processFn, finishFn) ->
    isFirst = true
    prefix = ','
    outputStream = fs.createWriteStream(options.output, {encoding: 'utf-8'})
    outputStream.on 'error', (error) => @_die 'Problem on output stream.\n', error
    outputStream.on 'finish', -> fs.appendFileSync options.output, ']}'

    processFn (payload) ->
      if isFirst
        outputStream.write "{\"total\": #{payload.body.total}, \"#{_.pluralize(options.type)}\": ["
        prefix = ''
        isFirst = false
      new Promise (resolve) ->
        _.each payload.body.results, (chunk) ->
          chunkString = if options.pretty then JSON.stringify(chunk, null, 2) else JSON.stringify(chunk)
          outputStream.write prefix + chunkString
        process.stdout.write('.')
        resolve()
    .then ->
      outputStream.end()
      process.stdout.write('\n')
      finishFn()
    .catch (e) => @_die 'Problem when processing stream.\n', e
