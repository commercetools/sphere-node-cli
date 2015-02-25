debug = require('debug')('sphere-import')
fs = require 'fs'
es = require 'event-stream'
JSONStream = require 'JSONStream'
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
    errors.push('Missing required option: from') unless options.from

    if errors.length > 0
      errors.forEach (e) -> log.error(e)
      process.exit(1)

  @_process: (type, from) =>
    switch type
      when 'stock' then @_processStock(from)
      else
        throw new Error "Unsupported type: #{type}"

  @_processStock: (from) =>
    rs = fs.createReadStream(from, {encoding: 'utf-8'})
    rs.pipe(JSONStream.parse('stocks.*'))
    .pipe(es.map (data, cb) ->
      log.info 'Chunk:', data
    )
    .pipe(process.stdout)
