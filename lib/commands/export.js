import _debug from 'debug'
import fs from 'fs'
import _ from 'underscore'
import _i from 'underscore.inflection'
import { ProductExport } from 'sphere-product-import'
import Command from '../utils/command'
import log from '../utils/logger'
import types from '../utils/types'

_.mixin(_i)
const debug = _debug('sphere-export')
const allowedTypes = _.pick(types, 'product')

export default class ExportCommand extends Command {

  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .option('-p, --project <key>',
        'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)')
      .option('-t, --type <name>',
        `type of export (#{_.keys(allowedTypes).join(' | ')})`)
      .option('-o, --output <path>', 'the output path where to write the JSON')
      .option('--pretty', 'whether the output JSON should be prettified')

    this.program.parse(argv)
    const options = _.pick(this.program, 'project', 'type', 'output', 'pretty')
    this._validateOptions(options, 'type')
    this._preProcess(options)
  }

  _process (options) {
    switch (options.type) {
    case allowedTypes.product:
      // TODO: make the query configurable
      // - predicate
      const service = new ProductExport(null, {
        config: options.credentials,
        user_agent: 'sphere-node-cli'
      })
      const processFn = _.bind(service.processStream, service)
      const finishFn = () => log.info(`Output written to ${options.output}`)
      return this._stream(options, processFn, finishFn)
    default:
      return this._die(`Unsupported type: ${options.type}`)
    }
  }

  _stream (options, processFn, finishFn) {
    let isFirst = true
    let prefix = ','
    const outputStream = fs.createWriteStream(
      options.output, { encoding: 'utf-8' })
    outputStream.on('error', error =>
      this._die('Problem on output stream.\n', error))
    outputStream.on('finish', () => fs.appendFileSync(options.output, ']}'))

    processFn(payload => {
      if (isFirst) {
        outputStream.write(
          `{"total": ${payload.body.total}, "${_.pluralize(options.type)}": [`)
        prefix = ''
        isFirst = false
      }

      return new Promise(resolve => {
        _.each(payload.body.results, chunk => {
          const chunkString = options.pretty
            ? JSON.stringify(chunk, null, 2)
            : JSON.stringify(chunk)
          outputStream.write(prefix + chunkString)
        })
        process.stdout.write('.')
        return resolve()
      })
    })
    .then(() => {
      outputStream.end()
      process.stdout.write('\n')
      return finishFn()
    })
    .catch(e => this._die('Problem when processing stream.\n', e))
  }
}
