# sphere-node-cli [![Build Status](https://secure.travis-ci.org/sphereio/sphere-node-cli.png?branch=master)](http://travis-ci.org/sphereio/sphere-node-cli)

Node.js [Command Line Tool](http://en.wikipedia.org/wiki/Command-line_interface) for [SPHERE.IO HTTP APIs](http://dev.sphere.io/).

## Installation

```bash
npm install sphere-node-cli -g
```

## Usage

`sphere` is most self documenting. Try any of these commands to get started

```bash
# will print general help
$ sphere

# Get info about `products` command
$ sphere help products
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
