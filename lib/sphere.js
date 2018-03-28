import _debug from 'debug'
import commander from 'commander'
import pkg from '../package.json'
import { isTest } from './utils/env'
import help from './utils/help'

const debug = _debug('sphere')

export default class SphereCommand {
  constructor () {
    this.program = commander
  }

  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .version(pkg.version)
      .command('import', 'Import resources')
      .on('--help', help)
      .parse(argv)

    if (!isTest && !this.program.args.length)
      this.program.help()
  }
}
