![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# Node.js CLI

[![npm](https://img.shields.io/npm/v/sphere-node-cli.svg)](https://www.npmjs.com/package/sphere-node-cli) [![Build Status](https://travis-ci.org/sphereio/sphere-node-cli.svg?branch=master)](https://travis-ci.org/sphereio/sphere-node-cli) [![sphere.io](https://img.shields.io/badge/api-%7B%22name%22:%20%22sphere.io%22%7D-yellow.svg?style=flat)](http://dev.sphere.io)

The next generation Command-Line-Interface for SPHERE.IO.

> If you were using the [old ruby CLI](https://github.com/sphereio/sphere-cli) make sure to uninstall it first.

## Getting Started

```bash
$ npm install -g sphere-node-cli

# show general help
$ sphere -h

# show help for a command (e.g.: import, export)
$ sphere help <cmd>
```

The CLI is **still under development** but already provides a bunch of commands.<br/>
The idea behind it is to operate as a _proxy_ for the different libraries that are used underneath. For example the `import` command will stream chunks from a given JSON file and pass them to the related library that will handled the rest.

Current available commands:

- **import** (`stock`, `product`, `price`)
- **export** (`product`)
- **fetch** (`product`)

## Commands

### `sphere-import`

```bash
# import some products
sphere import -p sample_project -t product -f sample_dir/products.json -c '{"errorDir":"./productErrors"}'
```

- a sample product JSON acceptable for the import module can be found [here](https://github.com/sphereio/sphere-product-import/blob/master/samples/sample-products.json)
- a detailed documentation about the product importer module can be found [here](https://github.com/sphereio/sphere-product-import/wiki/Product-Importer)
- a sample price JSON and detailed documentation about the price importer can be found [here](https://github.com/sphereio/sphere-product-import/wiki/Price-Importer)

TBD:
- JSON schema

## Development

See [Contribution guidelines](CONTRIBUTING.md)

```bash
$ npm i

# build sources
$ npm run build

# run tests
$ npm test
$ npm run test:watch
$ npm run test:features

# release (bump version, create tag, push it and publish to npm)
$ npm run release # alias for patch
$ npm run release:patch
$ npm run release:minor
$ npm run release:major
```
