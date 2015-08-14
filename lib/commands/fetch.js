import _debug from 'debug'
import _ from 'underscore'
import { SphereClient } from 'sphere-node-sdk'
import Command from '../utils/command'
import log from '../utils/logger'
import types from '../utils/types'

const debug = _debug('sphere-fetch')
const allowedTypes = _.pick(types, 'product')
const allowedTypesHelp = Object.keys(allowedTypes).join(' | ')

export default class FetchCommand extends Command {

  run (argv) {
    debug('parsing args: %s', argv)

    // TODO:
    // - support for queries via a JSON option / file
    this.program
      .option('-p, --project <key>',
        'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)')
      .option('-t, --type <name>',
        `type of API resource to fetch (${allowedTypesHelp})`)

    this.program.parse(argv)
    const options = _.pick(this.program, 'project', 'type')
    this._validateOptions(options, 'type')
    return this._preProcess(options)
  }

  _process (options) {
    const client = new SphereClient({
      config: options.credentials,
      user_agent: 'sphere-node-cli'
    })

    switch (options.type) {
    case allowedTypes.product:
      return this._fetch(client.products)
    default:
      return this._die(`Unsupported resource type: ${options.type}`)
    }
  }

  _fetch (service) {
    return service.fetch().then(result => log.info('%j', result, {}))
  }
}
