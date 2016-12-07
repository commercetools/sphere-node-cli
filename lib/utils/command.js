import _debug from 'debug'
import commander from 'commander'
import loadCredentials from './load-credentials'
import log from './logger'

const debug = _debug('sphere-command')

export default class Command {

  constructor () {
    this.program = commander
  }
  /* eslint-disable class-methods-use-this */
  run () {
    throw new Error('Base run method must be overridden')
  }

  _die () {
    log.error.apply(null, arguments) // eslint-disable-line prefer-rest-params
    process.exit(1)
  }

  _validateOptions (options, ...types) {
    const errors = types.reduce((acc, type) => {
      if (!options[type]) acc.push(type)
      return acc
    }, [])

    if (errors.length > 0)
      this._die(`Missing required options: ${errors.join(', ')}`)
  }

  _preProcess (options) {
    loadCredentials(options.project, options.accessToken)
    .then((credentials) => {
      debug('loaded credentials: %j', credentials)
      return this._parseConfig(options.config)
      .then(config =>
        this._process(Object.assign(options, { config, credentials }))
      )
    })
    .catch(err => this._die(err.message || err))
  }

  _parseConfig (config) {
    debug('parsing config: %j', config)
    if (!config)
      return Promise.resolve({})

    try {
      const parsed = JSON.parse(config)
      return Promise.resolve(parsed)
    } catch (e) {
      return this._die('Cannot parse config', e)
    }
  }

  _process () {
    throw new Error('Base _process method must be overridden')
  }

}
