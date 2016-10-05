import sinon from 'sinon'
import test from 'tape'
import FetchCommand from '../../lib/commands/fetch'

const _commander = require('rewire')('commander')

const BIN_DIR = `${__dirname}/../../bin`

const fakeCredentials = {
  project_key: 'foo',
  client_id: '123',
  client_secret: 'abc',
}

function before () {
  const command = new FetchCommand()
  command.program = _commander
  return Promise.resolve(command)
}

test(`FetchCommand
  should initialize command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.spy(command, '_validateOptions')
    const spy2 = sinon.stub(command, '_die')
    sinon.stub(command, '_preProcess') // just to stub it
    command.run(['node', `${BIN_DIR}/sphere-fetch`])
    t.equal(typeof command.program.name, 'function')
    t.equal(command.program.name(), 'sphere-fetch')
    t.equal(command.program.commands.length, 0)
    t.equal(command.program.options.length, 2)
    t.equal(command.program.options[0].flags, '-p, --project <key>')
    t.equal(command.program.options[1].flags, '-t, --type <name>')
    t.notOk(command.program.project)
    t.notOk(command.program.type)
    t.deepEqual(spy1.args[0][0], {})
    t.equal(spy1.args[0][1], 'type')
    t.equal(spy2.args[0][0], 'Missing required options: type')
    t.end()
  })
})

test(`FetchCommand
  should process command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_fetch')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
      Object.assign(opts, { credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-fetch`,
      '-p', 'foo', '-t', 'product'])
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'product')
    t.equal(spy1.args[0].length, 1)
    t.equal(spy2.calledOnce, true)
    t.end()
  })
})
