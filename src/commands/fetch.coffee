debug = require('debug')('sphere-fetch')
_ = require 'underscore'
{SphereClient} = require 'sphere-node-sdk'
BaseCommand = require '../utils/command'
log = require '../utils/logger'
types = require '../utils/types'

allowedTypes = _.pick(types, 'product')

module.exports = class extends BaseCommand

  run: (argv) ->
    debug 'parsing args: %s', argv

    # TODO:
    # - support for queries via a JSON option / file
    @program
      .option '-p, --project <key>', 'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)'
      .option '-t, --type <name>', "type of API resource to fetch (#{_.keys(allowedTypes).join(' | ')})"

    @program.parse(argv)
    options = _.pick(@program, 'project', 'type')
    @_validateOptions(options, 'type')
    @_preProcess(options)

  _process: (options) ->
    client = new SphereClient
      config: options.credentials
      user_agent: 'sphere-node-cli'

    switch options.type
      when allowedTypes.product
        @_fetch client.products
      else
        @_die "Unsupported resource type: #{options.type}"

  _fetch: (service) ->
    service.fetch().then (result) -> log.info '%j', result, {}
