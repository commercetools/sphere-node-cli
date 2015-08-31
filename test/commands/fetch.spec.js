import 'should'
import sinon from 'sinon'
import expect from 'expect'
import FetchCommand from '../../lib/commands/fetch'

const BIN_DIR = `${__dirname}/../../bin`

const fakeCredentials = {
  'project_key': 'foo',
  'client_id': '123',
  'client_secret': 'abc'
}

describe('FetchCommand', () => {
  let command

  beforeEach(() => {
    command = new FetchCommand()
    command.program = require('rewire')('commander')
  })

  it('should initialize command', () => {
    const spy1 = sinon.spy(command, '_validateOptions')
    const spy2 = sinon.stub(command, '_die')
    sinon.stub(command, '_preProcess') // just to stub it
    command.run(['node', `${BIN_DIR}/sphere-fetch`])
    command.program.name.should.be.a.Function
    command.program.name().should.equal('sphere-fetch')
    command.program.commands.should.have.lengthOf(0)
    command.program.options.should.have.lengthOf(2)
    command.program.options[0].flags.should.equal('-p, --project <key>')
    command.program.options[1].flags.should.equal('-t, --type <name>')
    command.program.should.not.have.property('project')
    command.program.should.not.have.property('type')
    expect(spy1.args[0][0]).toEqual({})
    expect(spy1.args[0][1]).toEqual('type')
    expect(spy2.args[0][0]).toEqual('Missing required options: type')
  })

  it('should process command', () => {
    const spy1 = sinon.stub(command, '_fetch')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
        Object.assign(opts, { credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-fetch`,
      '-p', 'foo', '-t', 'product'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('product')
    expect(spy1.args[0].length).toBe(1)
    expect(spy2.calledOnce).toBe(true)
  })
})
