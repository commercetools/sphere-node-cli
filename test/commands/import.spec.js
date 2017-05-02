import sinon from 'sinon'
import test from 'tape'
import ImportCommand from '../../lib/commands/import'

const _commander = require('rewire')('commander')

const BIN_DIR = `${__dirname}/../../bin`

const fakeCredentials = {
  project_key: 'foo',
  client_id: '123',
  client_secret: 'abc',
}

function before () {
  const command = new ImportCommand()
  command.program = _commander
  return Promise.resolve(command)
}

test(`ImportCommand
  should initialize command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.spy(command, '_validateOptions')
    const spy2 = sinon.stub(command, '_die')
    sinon.stub(command, '_preProcess') // just to stub it
    command.run(['node', `${BIN_DIR}/sphere-import`])
    t.equal(typeof command.program.name, 'function', 'Importcommand is a class')
    t.equal(
      command.program.name(),
      'sphere-import',
      'CLI command name is \'sphere-import\''
    )
    t.equal(command.program.commands.length, 0, 'No sub command args')
    t.equal(
      command.program.options.length,
      11,
      'There are 11 flags on the command'
    )
    t.equal(
      command.program.options[0].flags,
      '-p, --project <key>',
      '\'project\' flag is present'
    )
    t.equal(
      command.program.options[1].flags,
      '-t, --type <name>',
      '\'type\' flag is present'
    )
    t.equal(
      command.program.options[2].flags,
      '-f, --from <path>',
      '\'from\' is present'
    )
    t.equal(
      command.program.options[3].flags,
      '-b, --batch <n>',
      '\'batch\' flag is present'
    )
    t.equal(
      command.program.options[4].flags,
      '-c, --config <object>',
      '\'config\' is present'
    )
    t.equal(
      command.program.options[5].flags,
      '--plugin [path]',
      'plugin path flag is present'
    )
    t.equal(
      command.program.options[6].flags,
      '--accessToken [token]',
      'token flag is present'
    )
    t.notOk(
      command.program.project,
      'No default value is set for project'
    )
    t.notOk(
      command.program.type,
      'No default value is set for type'
    )
    t.notOk(
      command.program.from,
      'No default value is set for from'
    )
    t.notOk(
      command.program.config,
      'No default value is set for config'
    )
    t.ok(
      command.program.batch,
      'Default value(5) is set for batch'
    )
    t.deepEqual(
      spy1.args[0][0].batch,
      5,
      'Default value for batch flag is 5'
    )
    t.deepEqual(
      spy1.args[0][1],
      'type',
      'Type flag is passed to cli parser'
    )
    t.equal(
      spy2.args[0][0],
      'Missing required options: type',
      'Missing required options'
    )
    t.end()
  })
})

test(`ImportCommand
  should process stock command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
      Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'stock', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'stock',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'stocks.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess command is calledOnce')
    t.end()
  })
})
test(`ImportCommand
  should process product command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
        Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'product', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'product',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'products.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  })
})

test(`ImportCommand
  should process price command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
        Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'price', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'price',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'prices.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  })
})

test(`ImportCommand
  should process category command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
          Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'category', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'category',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'categories.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  })
})

test(`ImportCommand
  should process customer command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
          Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'customer', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli')
    t.equal(
      command.program.type,
      'customer',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'customers.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  })
})

test(`ImportCommand
  should process discount command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
          Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'discount', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'discount',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(
      spy1.args[0][1],
      'discounts.*',
      'type value is passed'
    )
    t.equal(
      spy1.args[0].length,
      4,
      'Correct number of args is parsed'
    )
    t.ok(
      spy2.calledOnce,
      '_preProcess is calledOnce'
    )
    t.end()
  })
})

test(`ImportCommand
  should process productType command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
      Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'productType', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'productType',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], 'productTypes.*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  }).catch(t.fail)
})

test(`ImportCommand
  should process order command`, (t) => {
  before().then((command) => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => command._process(
      Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    )
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'order', '-f', './foo.json'])
    t.equal(
      command.program.project,
      'foo',
      'project flag is parsed from the cli'
    )
    t.equal(
      command.program.type,
      'order',
      'type flag is parsed from the cli'
    )
    t.equal(
      command.program.from,
      './foo.json',
      'from flag is parsed from the cli'
    )
    t.equal(spy1.args[0][1], '*', 'type value is passed')
    t.equal(spy1.args[0].length, 4, 'Correct number of args is parsed')
    t.ok(spy2.calledOnce, '_preProcess is calledOnce')
    t.end()
  })
})
