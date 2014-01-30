program = require('commander')

console.log ''
console.log '    __  __      __  __  __     __'
console.log '   /_  /_/ /_/ /_  /_/ /_   / /  /'
console.log '  __/ /   / / /_  / \\ /_ . / /__/'
console.log ''

program
  .version('0.0.1')
  .option('-u, --user=email', 'account username')
  .option('-p, --password=pwd', 'account password')

program
  .command('auth', 'Provide credentials for authentication')
  .command('products', 'Manage products for a project')

program.parse(process.argv)
program.help() unless program.args.length
