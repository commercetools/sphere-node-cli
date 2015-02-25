_ = require 'underscore'
winston = require 'winston'

logger = new winston.Logger
  transports: [
    # TODO: provide custom options
    new winston.transports.Console
      colorize: true
      prettyPrint: true
  ]
  colors: _.extend winston.config.cli.colors,
    data: 'cyan'

# Important: will enable special helpers for CLI usage
# https://github.com/flatiron/winston#using-winston-in-a-cli-tool
logger.cli()

module.exports = logger
