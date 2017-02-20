import _debug from 'debug'
import fs from 'fs'
import { pluralize } from 'inflection'
import { ProductExport } from 'sphere-product-import'
import Command from '../utils/command'
import { userAgent } from '../utils/env'
import { isTest } from '../utils/env'
import * as types from '../utils/types'
import help from '../utils/help'
import log from '../utils/logger'
import pick from '../utils/pick'

const debug = _debug('sphere-export')
const allowedTypes = pick(types, 'product')
const allowedTypesHelp = Object.keys(allowedTypes).join(' | ')

const serviceMapping = {
  [allowedTypes.product]: options => {
    // TODO: make the query configurable
    // - predicate
    const service = new ProductExport(null, {
      config: options.credentials,
      'user_agent': userAgent
    })
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(`Output written to ${options.output}`)
    return [ options, processFn, finishFn ]
  }
}

export default class ExportCommand extends Command {

  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .option('-p, --project <key>',
        'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)')
      .option('-t, --type <name>', `type of export (${allowedTypesHelp})`)
      .option('-o, --output <path>', 'the output path where to write the JSON')
      .option('--pretty', 'whether the output JSON should be prettified')
      .on('--help', help)
      .parse(argv)

    if (!isTest && argv.length <= 3)
      this.program.help()

    const options = pick(this.program, 'project', 'type', 'output', 'pretty')
    this._validateOptions(options, 'type')
    this._preProcess(options)
  }

  _process (options) {
    const service = serviceMapping[options.type]
    if (service)
      return this._stream(...service(options))

    return this._die(`Unsupported type: ${options.type}`)
  }

  _stream (options, processFn, finishFn) {
    let isFirst = true
    let total = 0
    let prefix = ''

    return new Promise((resolve) => {
      const outputStream = fs.createWriteStream(
        options.output, { encoding: 'utf-8' })

      outputStream.on('error', error =>
        this._die('Problem on output stream.\n', error))

      outputStream.on('finish', () => {
        fs.appendFileSync(options.output, `], "total": ${total}}`)
        finishFn()
        resolve()
      })

      processFn(payload => {
        total += payload.body.results.length

        if (isFirst) {
          outputStream.write(
            `{"${pluralize(options.type)}": [`)
          isFirst = false
        }

        payload.body.results.forEach(chunk => {
          const chunkString = options.pretty
            ? JSON.stringify(chunk, null, 2)
            : JSON.stringify(chunk)
          outputStream.write(prefix + chunkString)
          prefix = ','
        })
        process.stdout.write('.')
        return Promise.resolve()
      })
        .then(() => {
          outputStream.end()
          process.stdout.write('\n')
        })
        .catch(e => this._die('Problem when processing stream.\n', e))
    })
  }
}
