import test from 'tape'
import SphereCommand from '../lib/sphere'

const _commander = require('rewire')('commander')

const BIN_DIR = `${__dirname}/../bin`

const command = new SphereCommand()
command.program = _commander
command.run(['node', `${BIN_DIR}/sphere`])

test(`SphereCommand
  should initialize command`, (t) => {
  t.equal(typeof command.program.name, 'function')
  t.equal(command.program.name(), 'sphere')
  t.equal(command.program.commands[0].name(), 'fetch')
  t.equal(command.program.commands[1].name(), 'export')
  t.equal(command.program.commands[2].name(), 'import')
  t.equal(command.program.commands[3].name(), 'help')
  t.equal(command.program.options.length, 1)
  t.equal(command.program.options[0].flags, '-V, --version')
  t.end()
})
