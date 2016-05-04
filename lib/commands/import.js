import _debug from 'debug'
import fs from 'fs'
import ___ from 'highland'
import transform from 'stream-transform'
import JSONStream from 'JSONStream'
import StockImport from 'sphere-stock-import'
import { ProductImport, PriceImport,
    ProductDiscountImport } from 'sphere-product-import'
import { CategoryImport } from 'sphere-category-sync'
import CustomerImport from 'sphere-customer-import'
import ProductTypeImport from 'sphere-product-type-import'
import Command from '../utils/command'
import { userAgent } from '../utils/env'
import { isTest } from '../utils/env'
import * as types from '../utils/types'
import help from '../utils/help'
import log from '../utils/logger'
import pick from '../utils/pick'

const debug = _debug('sphere-import')
const allowedTypes = pick(types, 'product', 'productType', 'stock', 'price',
    'category', 'customer', 'discount')
const allowedTypesHelp = Object.keys(allowedTypes).join(' | ')

const serviceMapping = {
  [allowedTypes.stock]: options => {
    const service = new StockImport(null, {
      config: options.credentials,
      'user_agent': userAgent
    })
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'stocks.*', processFn, finishFn ]
  },
  [allowedTypes.product]: options => {
    const service = new ProductImport(log,
      Object.assign({}, options.config, {
        clientConfig: {
          config: options.credentials,
          'user_agent': userAgent
        }
      }))
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'products.*', processFn, finishFn ]
  },
  [allowedTypes.price]: options => {
    const service = new PriceImport(log,
      Object.assign({}, options.config, {
        clientConfig: {
          config: options.credentials,
          'user_agent': userAgent
        }
      }))
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'prices.*', processFn, finishFn ]
  },
  [allowedTypes.category]: options => {
    const service = new CategoryImport(log,
      Object.assign({}, options.config, {
        config: options.credentials,
        'user_agent': userAgent
      }))
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'categories.*', processFn, finishFn ]
  },
  [allowedTypes.customer]: options => {
    const service = new CustomerImport(log,
      Object.assign({}, {
        importerConfig: options.config,
        sphereClientConfig: {
          config: options.credentials,
          'user_agent': userAgent
        }
      }))
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'customers.*', processFn, finishFn ]
  },
  [allowedTypes.productType]: options => {
    const service = new ProductTypeImport(log,
      Object.assign({}, {
        importerConfig: options.config,
        sphereClientConfig: {
          config: options.credentials,
          'user_agent': userAgent
        }
      }))
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'productTypes.*', processFn, finishFn ]
  },
  [allowedTypes.discount]: options => {
    const service = new ProductDiscountImport(log,
        Object.assign({}, options.config, {
          clientConfig: {
            config: options.credentials,
            'user_agent': userAgent
          }
        }))
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'discounts.*', processFn, finishFn ]
  }
}

export default class ImportCommand extends Command {

  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .option('-p, --project <key>',
        'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)')
      .option('-t, --type <name>', `type of import (${allowedTypesHelp})`)
      .option('-f, --from <path>',
        'the path to a JSON file where to read from')
      .option('-b, --batch <n>',
        'how many chunks should be processed in batches (default: 5)',
        parseInt, 5)
      .option('-c, --config <object>',
        'a JSON object as a string to be passed to the related library, ' +
        'usually containing specific configuration options')
      .on('--help', help)
      .parse(argv)

    if (!isTest && argv.length <= 3)
      this.program.help()

    const options = pick(this.program,
      'project', 'type', 'from', 'batch', 'config')
    this._validateOptions(options, 'type')
    return this._preProcess(options)
  }

  _process (options) {
    const service = serviceMapping[options.type]
    if (service)
      return this._stream(...service(options))

    return this._die(`Unsupported type: ${options.type}`)
  }

  _stream (options, jsonPath, processFn, finishFn) {
    let inputStream
    if (options.from)
      inputStream = fs.createReadStream(options.from, { encoding: 'utf-8' })
    else {
      log.info('Reading data from stdin...')
      process.stdin.resume()
      process.stdin.setEncoding('utf8')
      inputStream = process.stdin
    }

    const transformStream = ___(inputStream.pipe(JSONStream.parse(jsonPath)))
    .stopOnError(e => this._die('Cannot parse chunk as JSON.\n', e))
    .batch(options.batch)
    .pipe(transform((chunk, cb) => {
      process.stdout.write('.')
      return processFn(chunk, cb)
      .catch(error => cb(error ? (error.body || error) : null))
    // We want to process one chunk at a time
    // (chunk size is determined by batch value)
    }, { parallel: 1 }))

    // This trick allows to accumulate the stream to a single value
    // and pull it so that we know all chunks have been processed
    // and we can display a final message
    return ___(transformStream).reduce(null, () => '')
    .stopOnError(e =>
      this._die('Something went wrong while transforming chunks.\n', e))
    .pull(err => err ? log.error(err) : finishFn())
  }
}
