program = require('commander')
auth_utils = require('../utils/auth')

program
  .command('save')
  .description('Save auth credentials locally')
  .action -> auth_utils.saveCredentials()

program
  .command('load')
  .description('Load auth credentials')
  .action -> auth_utils.loadCredentials()

program.parse(process.argv)
program.help() unless program.args.length
