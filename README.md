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

# !!!Still under development!!!
> Each released version is tested and stable, so you can already install the CLI and use it.

Features will be implemented step-by-step (see also Issues).

Current available commands:

- **import** (`stock`, `product`, `price`)
- **export** (`product`)
- **fetch** (`product`)


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
## Usage Examples

#### Product Import

A sample command for running product import 

`./bin/sphere import -p sample_project -t product -f sample_dir/products.json -c '{"errorDir":"../productErrors"}'`

A sample JSON acceptable for the import module can be found [here](https://github.com/sphereio/sphere-product-import/blob/master/samples/sample-products.json)

A detailed documentation about the product importer module can be found [here](https://github.com/sphereio/sphere-product-import/wiki/Product-Importer)

#### Price Import

A sample JSON and detailed documentation about the price importer can be found [here](https://github.com/sphereio/sphere-product-import/wiki/Price-Importer)