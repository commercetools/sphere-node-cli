import 'should'
import SphereCommand from '../lib/sphere'

const rewire = require('rewire')('commander')

const BIN_DIR = `${__dirname}/../bin`

describe('SphereCommand', () => {
  let command

  beforeEach(() => {
    command = new SphereCommand()
    command.program = rewire
    command.run(['node', `${BIN_DIR}/sphere`])
  })

  it('should initialize command', () => {
    // eslint-disable-next-line no-unused-expressions
    command.program.name.should.be.a.Function
    command.program.name().should.equal('sphere')
    command.program.commands[0].name().should.equal('fetch')
    command.program.commands[1].name().should.equal('export')
    command.program.commands[2].name().should.equal('import')
    command.program.commands[3].name().should.equal('help')
    command.program.options.should.have.lengthOf(1)
    command.program.options[0].flags.should.equal('-V, --version')
  })
})
