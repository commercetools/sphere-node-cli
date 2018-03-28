import _debug from 'debug'
import fs from 'fs'
import ___ from 'highland'
import transform from 'stream-transform'
import JSONStream from 'JSONStream'
import StockImport from 'sphere-stock-import'
import {
  ProductImport, PriceImport,
  ProductDiscountImport,
} from 'sphere-product-import'
import { CategoryImport } from 'sphere-category-sync'
import CustomerImport from 'sphere-customer-import'
import ProductTypeImport from 'sphere-product-type-import'
import OrdersUpdate from '@commercetools/orders-update'
import DiscountCodeImporter from '@commercetools/discount-code-importer'
import StateImporter from '@commercetools/state-importer'
import Command from '../utils/command'
import { userAgent, isTest } from '../utils/env'
import * as types from '../utils/types'
import help from '../utils/help'
import log from '../utils/logger'
import pick from '../utils/pick'

const debug = _debug('sphere-import')
const allowedTypes = pick(
  types, 'product', 'productType', 'stock', 'price',
  'category', 'customer', 'discount', 'order', 'discountCode', 'state',
)
const allowedTypesHelp = Object.keys(allowedTypes).join(' | ')

const serviceMapping = {
  [allowedTypes.stock]: (options) => {
    const service = new StockImport(null, {
      config: options.credentials,
      user_agent: userAgent,
      access_token: options.accessToken,
      host: options.host,
      protocol: options.protocol,
      oauth_host: options.authHost,
      oauth_protocol: options.authProtocol,
    })
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'stocks.*', processFn, finishFn ]
  },
  [allowedTypes.product]: (options) => {
    const service = new ProductImport(
      log,
      Object.assign({}, options.config, {
        clientConfig: {
          config: options.credentials,
          user_agent: userAgent,
          access_token: options.accessToken,
          host: options.host,
          protocol: options.protocol,
          oauth_host: options.authHost,
          oauth_protocol: options.authProtocol,
        },
      }),
    )
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'products.*', processFn, finishFn ]
  },
  [allowedTypes.price]: (options) => {
    const service = new PriceImport(
      log,
      Object.assign({}, options.config, {
        clientConfig: {
          config: options.credentials,
          user_agent: userAgent,
          access_token: options.accessToken,
          host: options.host,
          protocol: options.protocol,
          oauth_host: options.authHost,
          oauth_protocol: options.authProtocol,
        },
      }),
    )
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'prices.*', processFn, finishFn ]
  },
  [allowedTypes.category]: (options) => {
    const service = new CategoryImport(
      log,
      Object.assign({}, options.config, {
        config: options.credentials,
        user_agent: userAgent,
        access_token: options.accessToken,
        host: options.host,
        protocol: options.protocol,
        oauth_host: options.authHost,
        oauth_protocol: options.authProtocol,
      }),
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'categories.*', processFn, finishFn ]
  },
  [allowedTypes.customer]: (options) => {
    const service = new CustomerImport(
      log,
      Object.assign({}, {
        importerConfig: options.config,
        sphereClientConfig: {
          config: options.credentials,
          user_agent: userAgent,
          access_token: options.accessToken,
          host: options.host,
          protocol: options.protocol,
          oauth_host: options.authHost,
          oauth_protocol: options.authProtocol,
        },
      }),
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'customers.*', processFn, finishFn ]
  },
  [allowedTypes.productType]: (options) => {
    const service = new ProductTypeImport(
      log,
      Object.assign({}, {
        importerConfig: options.config,
        sphereClientConfig: {
          config: options.credentials,
          user_agent: userAgent,
          access_token: options.accessToken,
          host: options.host,
          protocol: options.protocol,
          oauth_host: options.authHost,
          oauth_protocol: options.authProtocol,
        },
      }),
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'productTypes.*', processFn, finishFn ]
  },
  [allowedTypes.discount]: (options) => {
    const service = new ProductDiscountImport(
      log,
      Object.assign({}, options.config, {
        clientConfig: {
          config: options.credentials,
          user_agent: userAgent,
          access_token: options.accessToken,
          host: options.host,
          protocol: options.protocol,
          oauth_host: options.authHost,
          oauth_protocol: options.authProtocol,
        },
      }),
    )
    const processFn = service.performStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, 'discounts.*', processFn, finishFn ]
  },
  [allowedTypes.order]: (options) => {
    const service = new OrdersUpdate(
      Object.assign({}, options.config, {
        config: options.credentials,
        user_agent: userAgent,
        access_token: options.accessToken,
        host: options.host,
        protocol: options.protocol,
        oauth_host: options.authHost,
        oauth_protocol: options.authProtocol,
      }),
      log,
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, '*', processFn, finishFn ]
  },
  [allowedTypes.discountCode]: (options) => {
    const service = new DiscountCodeImporter(
      Object.assign({}, options.config, {
        apiConfig: {
          host: options.authHost,
          projectKey: options.credentials.project_key,
          credentials: {
            clientId: options.credentials.client_id,
            clientSecret: options.credentials.client_secret,
          },
          apiUrl: options.host,
          protocol: options.protocol,
          oauth_protocol: options.authProtocol,
        },
        accessToken: options.accessToken,
        batchSize: options.batch,
      }),
      log,
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, '*', processFn, finishFn ]
  },
  [allowedTypes.state]: (options) => {
    const service = new StateImporter(
      Object.assign({}, options.config, {
        apiConfig: {
          host: options.authHost,
          projectKey: options.credentials.project_key,
          credentials: {
            clientId: options.credentials.client_id,
            clientSecret: options.credentials.client_secret,
          },
          apiUrl: options.host,
          protocol: options.protocol,
          oauth_protocol: options.authProtocol,
        },
        accessToken: options.accessToken,
      }),
      log,
    )
    const processFn = service.processStream.bind(service)
    const finishFn = () => log.info(service.summaryReport(options.from))
    return [ options, '*', processFn, finishFn ]
  },
}

export default class ImportCommand extends Command {
  run (argv) {
    debug('parsing args: %s', argv)

    this.program
      .option(
        '-p, --project <key>',
        'the key of a SPHERE.IO project for credentials lookup ' +
        '(if not provided, will try to read credentials from ENV variables)',
      )
      .option('-t, --type <name>', `type of import (${allowedTypesHelp})`)
      .option(
        '-f, --from <path>',
        'the path to a JSON file where to read from',
      )
      .option(
        '-b, --batch <n>',
        'how many chunks should be processed in batches (default: 5)',
        num => parseInt(num, 10), 5,
      )
      .option(
        '-c, --config <object>',
        'a JSON object as a string to be passed to the related library, ' +
        'usually containing specific configuration options',
      )
      .option('--plugin [path]', 'the absolute path to a custom plugin')
      .option(
        '--accessToken [token]',
        `an OAuth access token for the SPHERE.IO API,
        used instead of clientId and clientSecret`,
      )
      .option('--host [url]', 'commercetools host to connect to')
      .option(
        '--protocol [protocol]',
        'commercetools protocol to use when connecting',
      )
      .option('--authHost [url]', 'commercetools OAuth to connect to')
      .option(
        '--authProtocol [protocol]',
        'commercetools OAuth protocol to use when connecting',
      )
      .on('--help', help)
      .parse(argv)

    if (!isTest && argv.length <= 3)
      this.program.help()

    const options = Object.assign({}, this.program)
    if (!options.plugin)
      this._validateOptions(options, 'type')

    return this._preProcess(options)
  }

  _process (options) {
    if (options.plugin)
      return this._processWithPlugin(options)

    const service = serviceMapping[options.type]
    if (service)
      return this._stream(...service(options))

    return this._die(`Unsupported type: ${options.type}`)
  }

  _processWithPlugin (options) {
    const { plugin } = options
    // eslint-disable-next-line global-require, import/no-dynamic-require
    const service = require(plugin)
    return this._stream(...service(options))
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
          .catch(error => cb(error ? (error.body || error) : null))
        // We want to process one chunk at a time
        // (chunk size is determined by batch value)
      }, { parallel: 1 }))

    // This trick allows to accumulate the stream to a single value
    // and pull it so that we know all chunks have been processed
    // and we can display a final message
    return ___(transformStream).reduce(null, () => '')
      .stopOnError(e =>
        this._die('Something went wrong while transforming chunks.\n', e))
      .pull(err => (err ? log.error(err) : finishFn()))
  }
}
