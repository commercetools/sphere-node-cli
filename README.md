![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# Node.js CLI

[![npm](https://img.shields.io/npm/v/sphere-node-cli.svg)](https://www.npmjs.com/package/sphere-node-cli) [![Build Status](https://travis-ci.org/sphereio/sphere-node-cli.svg?branch=master)](https://travis-ci.org/sphereio/sphere-node-cli) [![sphere.io](https://img.shields.io/badge/api-%7B%22name%22:%20%22sphere.io%22%7D-yellow.svg?style=flat)](http://dev.sphere.io)

The next generation Command-Line-Interface for SPHERE.IO.

> If you were using the [old ruby CLI](https://github.com/sphereio/sphere-cli) make sure to uninstall it first.

# Table of Content

- [Getting Started](#getting-started)
- [Credentials](#credentials)
- [Commands](#commands)
  - [`sphere-import`](#sphere-import)
  - [`sphere-export`](#sphere-export)
  - [`sphere-fetch`](#sphere-fetch)
- [Development](#development)

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
-v /etc/sphere-project-credentials.json:/etc/sphere-project-credentials.json \
sphereio/sphere-node-cli -h
```

Import a product (host folder `/sample_dir/` mounted as docker volume)
```bash
docker run \
-v /etc/sphere-project-credentials.json:/etc/sphere-project-credentials.json \
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

- **import** (`stock`, `product`, `price`, `category`, `discount`)
- **export** (`product`)
- **fetch** (`product`)

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

- [Product import](https://github.com/sphereio/sphere-product-import/wiki/Product-Importer)
- [Price import](https://github.com/sphereio/sphere-product-import/wiki/Price-Importer)
- [Category import](https://github.com/sphereio/sphere-category-sync#json-format)
- [Product Discount import](https://github.com/sphereio/sphere-product-import/wiki/Product-Discounts-Importer)
- [Stock import]() _TBD_

#### `sphere-export`

TBD

#### `sphere-fetch`

TBD

## Development

See [Contribution guidelines](CONTRIBUTING.md)

```bash
$ npm i

# build sources
$ npm run build

# lint code
$ npm run lint

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
