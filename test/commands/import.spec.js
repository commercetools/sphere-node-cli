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
    t.equal(typeof command.program.name, 'function')
    t.equal(command.program.name(), 'sphere-import')
    t.equal(command.program.commands.length, 0)
    t.equal(command.program.options.length, 6)
    t.equal(command.program.options[0].flags, '-p, --project <key>')
    t.equal(command.program.options[1].flags, '-t, --type <name>')
    t.equal(command.program.options[2].flags, '-f, --from <path>')
    t.equal(command.program.options[3].flags, '-b, --batch <n>')
    t.equal(command.program.options[4].flags, '-c, --config <object>')
    t.equal(command.program.options[5].flags, '--plugin <path>')
    t.notOk(command.program.project)
    t.notOk(command.program.type)
    t.notOk(command.program.from)
    t.notOk(command.program.config)
    t.ok(command.program.batch)
    t.deepEqual(spy1.args[0][0], { batch: 5 })
    t.deepEqual(spy1.args[0][1], 'type')
    t.equal(spy2.args[0][0], 'Missing required options: type')
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'stock')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'stock',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'stocks.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'product')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'product',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'products.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'price')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'price',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'prices.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'category')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'category',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'categories.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'customer')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'customer',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'customers.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'discount')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'discount',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'discounts.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
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
    t.equal(command.program.project, 'foo')
    t.equal(command.program.type, 'productType')
    t.equal(command.program.from, './foo.json')
    t.deepEqual(spy1.args[0][0], {
      project: 'foo',
      type: 'productType',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials,
    })
    t.equal(spy1.args[0][1], 'productTypes.*')
    t.equal(spy1.args[0].length, 4)
    t.equal(spy2.calledOnce, true)
    t.end()
  })
})
