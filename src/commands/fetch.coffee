debug = require('debug')('sphere-fetch')
_ = require 'underscore'
{SphereClient} = require 'sphere-node-sdk'
BaseCommand = require '../utils/command'
log = require '../utils/logger'

module.exports = class extends BaseCommand

  run: (argv) ->
    debug 'parsing args: %s', argv

    # TODO:
    # - support for queries via a JSON option / file
    @program
      .option '-p, --project <key>', 'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)'
      .option '-t, --type <name>', 'type of API resource to fetch'

    @program.parse(argv)
    options = _.pick(@program, 'project', 'type')
    @_validateOptions(options, 'type')
    @_preProcess(options)

  _process: (options) ->
    client = new SphereClient
      config: options.credentials
      user_agent: 'sphere-node-cli'

    switch options.type
      when 'products'
        @_fetch client.products
      else
        @_die "Unsupported resource type: #{type}"

  _fetch: (service) ->
    service.fetch().then (result) -> console.log result
