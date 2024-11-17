<div style="background-color: yellow; color: black; padding: 10px; text-align: center; font-weight: bold;">
  <h2>🚨 Non-maintainable 🚨</h2>
  <p>Starting January 1, 2025, we will no longer provide maintenance or updates for the CLI ImpEx tools. After this date, this tool will no longer receive bug fixes, security patches, or new features.</p>
</div>


<img src="https://impex.europe-west1.gcp.commercetools.com/static/images/ct-logo.svg" alt="commercetools logo" width="200">


# Node.js CLI

[![npm][npm-icon]][npm]
[![Travis Build Status][travis-icon]][travis]
[![Codecov Coverage Status][codecov-icon]][codecov]
[![David Dependencies Status][david-icon]][david]
[![David devDependencies Status][david-dev-icon]][david-dev]

The next generation Command-Line-Interface for SPHERE.IO.

Table of Contents
=================

* [Features](#features)
* [Requirements](#requirements)
* [Usage](#usage)
* [Credentials](#credentials)
* [Docker](#docker)
  * [Examples](#examples)
* [Commands](#commands)
    * [sphere-import](#sphere-import)
* [Contributing](#contributing)

## Features
- import of `stock`, `product`, `price`, `category`, `discount`, `order`, `customer`, `productType`, `discountCode`, `state`, `customObject`
- Docker support
- Custom plugin

## Requirements
Make sure you have installed all of the following prerequisites on your development machine:
  * Git - [Download & Install Git](https://git-scm.com/downloads). MacOS and Linux machines typically have this already installed.
  * Node.js - [Download & Install Node.js](https://nodejs.org/en/download/) and the npm package manager. Make sure to get the latest active LTS version. You could also use a Node.js version manager such as [n](https://github.com/tj/n) or [nvm](https://github.com/creationix/nvm).

> If you were using the [old ruby CLI](https://github.com/sphereio/sphere-cli) make sure to uninstall it first.

## Usage

```bash
$ npm install -g sphere-node-cli

# show general help
$ sphere -h

# show help for a command (e.g.: import)
$ sphere help <cmd>

```
The CLI is **still under development** but already provides a bunch of commands.<br/>
The idea behind it is to operate as a _proxy_ for the different libraries that are used underneath. For example the `import` command will stream chunks from a given JSON file and pass them to the related library that will handled the rest.


## Credentials

The CLI has a lookup mechanism to load SPHERE.IO project credentials.<br/>
If you specify a `-p, --project` option, the CLI will try to load the credentials for that project from the following locations:

```
./.sphere-project-credentials
./.sphere-project-credentials.json
~/.sphere-project-credentials
~/.sphere-project-credentials.json
/etc/sphere-project-credentials
/etc/sphere-project-credentials.json
```

There are 2 supported formats: `csv` and `json`.

- **csv**: `project_key:client_id:client_secret`
- **json**: `{ "project_key": { "client_id": "", "client_secret": "" } }`

If no `-p, --project` option is provided, the CLI tries to read the credentials from ENV variables:

```
export SPHERE_PROJECT_KEY=""
export SPHERE_CLIENT_ID=""
export SPHERE_CLIENT_SECRET=""
```

## Docker

[![Docker build](http://dockeri.co/image/sphereio/sphere-node-cli)](https://registry.hub.docker.com/u/sphereio/sphere-node-cli/)

You need to have a working docker client! The [Docker Toolbox](https://www.docker.com/toolbox) is an installer to quickly and easily install and setup a Docker environment on your computer. Available for both Windows and Mac, the Toolbox installs Docker Client, Machine, Compose, Kitematic and VirtualBox.

### Examples

Show help
```bash
docker run \
sphereio/sphere-node-cli -h
```

Import a product (host folder `/sample_dir/` mounted as docker volume)
```bash
docker run \
-e SPHERE_PROJECT_KEY=<KEY>
-e SPHERE_CLIENT_ID=<ID>
-e SPHERE_CLIENT_SECRET=<SECRET>
-v /sample_dir/:/sample_dir/ \
sphereio/sphere-node-cli
import -p my-project-key -t product -f /sample_dir/products.json'
```

You can also set an alias for repeated calls:

```bash
alias sphere='docker run \
-v /etc/sphere-project-credentials.json:/etc/sphere-project-credentials.json \
sphereio/sphere-node-cli'
```

## Commands

The CLI has _git-like_ sub-commands which can be invoked as `sphere <cmd>`.

Current available commands:

- **import** (`stock`, `product`, `price`, `category`, `discount`, `order`, `customer`, `productType`, `discountCode`, `state`, `customObject`)

Commands expects at least a `-t, --type` option which may vary for each command.

#### `sphere-import`

Imports a resource `type` by streaming the input JSON file.

```bash
$ sphere import -p my-project-key -t product \
  -f sample_dir/products.json \
  -c '{"errorDir": "./productErrors"}'
```

The input must be a valid JSON following a specific schema (`import-type-key` is the _plural_ form of the `type` option, e.g.: `products`, `stocks`, etc.).

```json
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "SPHERE.IO CLI import schema",
  "type": "object",
  "properties": {
    "<import-type-key>": {
      "type": "array",
      "items": {
        "$ref": "https://github.com/sphereio/sphere-json-schemas/tree/master/schema"
      }
    }
  },
  "additionalProperties": false,
  "required": ["<import-type-key>"]
}
```

> If you don't provide a file to read _from_, the CLI listens from `stdin` so you can i.e. pipe in something.


Each import type might have / expect some extra specific configuration. In that case you have to refer to the related documentation.

- [Product import](https://github.com/sphereio/sphere-product-import/blob/master/readme/product-import.md)
- [Product Type import](https://github.com/sphereio/sphere-product-type-import)
- [Price import](https://github.com/sphereio/sphere-product-import/blob/master/readme/price-importer.md)
- [Category import](https://github.com/sphereio/sphere-category-sync#json-format)
- [Product Discount import](https://github.com/sphereio/sphere-product-import/blob/master/readme/product-discounts-importer.md)
- [Customer import](https://github.com/sphereio/customer-import)
- [Stock import](https://github.com/sphereio/sphere-stock-import)
- [Order import](https://github.com/commercetools/orders-update)
- [Discount Code import](https://commercetools.github.io/nodejs/cli/discount-code-importer.html)
- [State import](https://commercetools.github.io/nodejs/cli/state-importer.html)
- [Custom Object import](https://commercetools.github.io/nodejs/cli/custom-objects-importer.html)

## Contributing

See [Contribution guidelines](CONTRIBUTING.md)

[commercetools]: https://commercetools.com/
[commercetools-icon]: https://cdn.rawgit.com/commercetools/press-kit/master/PNG/72DPI/CT%20logo%20horizontal%20RGB%2072dpi.png
[npm-icon]: https://img.shields.io/npm/v/sphere-node-cli.svg
[npm]: https://www.npmjs.com/package/sphere-node-cli
[travis]: https://travis-ci.org/sphereio/sphere-node-cli
[travis-icon]: https://img.shields.io/travis/sphereio/sphere-node-cli/master.svg?style=flat-square
[codecov]: https://codecov.io/gh/sphereio/sphere-node-cli
[codecov-icon]: https://img.shields.io/codecov/c/github/sphereio/sphere-node-cli.svg?style=flat-square
[david]: https://david-dm.org/sphereio/sphere-node-cli
[david-icon]: https://img.shields.io/david/sphereio/sphere-node-cli.svg?style=flat-square
[david-dev]: https://david-dm.org/sphereio/sphere-node-cli?type=dev
[david-dev-icon]: https://img.shields.io/david/dev/sphereio/sphere-node-cli.svg?style=flat-square
