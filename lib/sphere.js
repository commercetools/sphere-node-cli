import _debug from 'debug'
import pkg from '../package.json'
import { ENV } from './utils/env'
import help from './utils/help'

const debug = _debug('sphere')

export default class Sphere {

  constructor () {
    this.program = require('commander')
  }

  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .version(pkg.version)
      .command('fetch', 'Fetch resources')
      .command('export', 'Export resources')
      .command('import', 'Import resources')
      .on('--help', help)
      .parse(argv)

    if (ENV !== 'test' && !thisprogram.args.length)
      this.program.help()
  }
}
