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
  .option('-j, --json-pretty', 'output in pretty-printed JSON')
  .option('-J, --json-raw', 'output in raw JSON')

program
  .command('products', 'Manage products for a project')

program.parse(process.argv)

program.help() unless program.args.length
