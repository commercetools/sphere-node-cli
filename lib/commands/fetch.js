import _debug from 'debug'
import { SphereClient } from 'sphere-node-sdk'
import Command from '../utils/command'
import { userAgent, isTest } from '../utils/env'
import * as types from '../utils/types'
import help from '../utils/help'
import log from '../utils/logger'
import pick from '../utils/pick'

const debug = _debug('sphere-fetch')
const allowedTypes = pick(types, 'product')
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
      .on('--help', help)
      .parse(argv)

    if (!isTest && argv.length <= 3)
      this.program.help()

    const options = pick(this.program, 'project', 'type')
    this._validateOptions(options, 'type')
    return this._preProcess(options)
  }

  _process (options) {
    const client = new SphereClient({
      config: options.credentials,
      user_agent: userAgent,
    })

    switch (options.type) {
    case allowedTypes.product:
      return this._fetch(client.products)
    default:
      return this._die(`Unsupported resource type: ${options.type}`)
    }
  }

  _fetch (service) { // eslint-disable-line class-methods-use-this
    return service.fetch().then(result => log.info('%j', result, {}))
  }
}
