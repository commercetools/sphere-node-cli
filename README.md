![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# Node.js CLI

[![Build Status](https://secure.travis-ci.org/sphereio/sphere-node-cli.png?branch=master)](http://travis-ci.org/sphereio/sphere-node-cli) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-node-cli/badge.png?branch=master)](https://coveralls.io/r/sphereio/sphere-node-cli?branch=master) [![Dependency Status](https://david-dm.org/sphereio/sphere-node-cli.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-node-cli) [![devDependency Status](https://david-dm.org/sphereio/sphere-node-cli/dev-status.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-node-cli#info=devDependencies)

Node.js [Command Line Tool](http://en.wikipedia.org/wiki/Command-line_interface) for [SPHERE.IO HTTP APIs](http://dev.sphere.io/).

## Installation

```bash
npm install sphere-node-cli -g
```

```bash
  Usage: sphere [options] [command]

  Commands:

    auth                   Provide credentials for authentication
    products               Manage products for a project
    help [cmd]             display help for [cmd]

  Options:

    -h, --help     output usage information
    -V, --version  output the version number


    __  __      __  __  __     __
   /_  /_/ /_/ /_  /_/ /_   / /  /
  __/ /   / / /_  / \ /_ . / /__/
```

## Usage

`sphere` is most self documenting. Try any of these commands to get started

```bash
# will print general help
$ sphere

# Get info about `products` command
$ sphere help products
```

## Developing locally
Install all needed dependencies, build the project and run the executable

```bash
$ npm install
...

$ grunt build
...

$ ./bin/sphere
$ ./bin/sphere help
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).
More info [here](CONTRIBUTING.md)

## Releasing
Releasing a new version is completely automated using the Grunt task `grunt release`.

```javascript
grunt release // patch release
grunt release:minor // minor release
grunt release:major // major release
```

## License
Copyright (c) 2014 Nicola Molinari
Licensed under the MIT license.
