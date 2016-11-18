import winston from 'winston'

const logger = new winston.Logger({
  transports: [
    // TODO: provide custom options
    new winston.transports.Console({
      prettyPrint: true,
    }),
  ],
  colors: Object.assign({}, winston.config.cli.colors,
    { data: 'cyan' }),
})

// Important: will enable special helpers for CLI usage
// https://github.com/flatiron/winston#using-winston-in-a-cli-tool
logger.cli()

export default logger
