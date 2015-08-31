import 'should'
import sinon from 'sinon'
import expect from 'expect'
import ExportCommand from '../../lib/commands/export'

const BIN_DIR = `${__dirname}/../../bin`

const fakeCredentials = {
  'project_key': 'foo',
  'client_id': '123',
  'client_secret': 'abc'
}

describe('ExportCommand', () => {
  let command

  beforeEach(() => {
    command = new ExportCommand()
    command.program = require('rewire')('commander')
  })

  it('should initialize command', () => {
    const spy1 = sinon.spy(command, '_validateOptions')
    const spy2 = sinon.stub(command, '_die')
    sinon.stub(command, '_preProcess') // just to stub it
    command.run(['node', `${BIN_DIR}/sphere-export`])
    command.program.name.should.be.a.Function
    command.program.name().should.equal('sphere-export')
    command.program.commands.should.have.lengthOf(0)
    command.program.options.should.have.lengthOf(4)
    command.program.options[0].flags.should.equal('-p, --project <key>')
    command.program.options[1].flags.should.equal('-t, --type <name>')
    command.program.options[2].flags.should.equal('-o, --output <path>')
    command.program.options[3].flags.should.equal('--pretty')
    command.program.should.not.have.property('project')
    command.program.should.not.have.property('type')
    command.program.should.not.have.property('output')
    command.program.should.not.have.property('pretty')
    expect(spy1.args[0][0]).toEqual({})
    expect(spy1.args[0][1]).toEqual('type')
    expect(spy2.args[0][0]).toEqual('Missing required options: type')
  })

  it('should process command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
        Object.assign(opts, { credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-export`,
      '-p', 'foo', '-t', 'product', '-o', './export.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('product')
    command.program.output.should.be.equal('./export.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'product',
      output: './export.json',
      credentials: fakeCredentials
    })
    expect(spy1.args[0].length).toBe(3)
    expect(spy2.calledOnce).toBe(true)
  })
})
