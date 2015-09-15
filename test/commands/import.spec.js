import 'should'
import sinon from 'sinon'
import expect from 'expect'
import ImportCommand from '../../lib/commands/import'

const BIN_DIR = `${__dirname}/../../bin`

const fakeCredentials = {
  'project_key': 'foo',
  'client_id': '123',
  'client_secret': 'abc'
}

describe('ImportCommand', () => {
  let command

  beforeEach(() => {
    command = new ImportCommand()
    command.program = require('rewire')('commander')
  })

  it('should initialize command', () => {
    const spy1 = sinon.spy(command, '_validateOptions')
    const spy2 = sinon.stub(command, '_die')
    sinon.stub(command, '_preProcess') // just to stub it
    command.run(['node', `${BIN_DIR}/sphere-import`])
    command.program.name.should.be.a.Function
    command.program.name().should.equal('sphere-import')
    command.program.commands.should.have.lengthOf(0)
    command.program.options.should.have.lengthOf(5)
    command.program.options[0].flags.should.equal('-p, --project <key>')
    command.program.options[1].flags.should.equal('-t, --type <name>')
    command.program.options[2].flags.should.equal('-f, --from <path>')
    command.program.options[3].flags.should.equal('-b, --batch <n>')
    command.program.options[4].flags.should.equal('-c, --config <object>')
    command.program.should.not.have.property('project')
    command.program.should.not.have.property('type')
    command.program.should.not.have.property('from')
    command.program.should.not.have.property('config')
    command.program.should.have.property('batch')
    expect(spy1.args[0][0]).toEqual({ batch: 5 })
    expect(spy1.args[0][1]).toEqual('type')
    expect(spy2.args[0][0]).toEqual('Missing required options: type')
  })

  it('should process stock command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
        Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'stock', '-f', './foo.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('stock')
    command.program.from.should.be.equal('./foo.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'stock',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials
    })
    expect(spy1.args[0][1]).toBe('stocks.*')
    expect(spy1.args[0].length).toBe(4)
    expect(spy2.calledOnce).toBe(true)
  })

  it('should process product command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
        Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'product', '-f', './foo.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('product')
    command.program.from.should.be.equal('./foo.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'product',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials
    })
    expect(spy1.args[0][1]).toBe('products.*')
    expect(spy1.args[0].length).toBe(4)
    expect(spy2.calledOnce).toBe(true)
  })

  it('should process price command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
        Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'price', '-f', './foo.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('price')
    command.program.from.should.be.equal('./foo.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'price',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials
    })
    expect(spy1.args[0][1]).toBe('prices.*')
    expect(spy1.args[0].length).toBe(4)
    expect(spy2.calledOnce).toBe(true)
  })

  it('should process category command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
          Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'category', '-f', './foo.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('category')
    command.program.from.should.be.equal('./foo.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'category',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials
    })
    expect(spy1.args[0][1]).toBe('categories.*')
    expect(spy1.args[0].length).toBe(4)
    expect(spy2.calledOnce).toBe(true)
  })

  it('should process discount command', () => {
    const spy1 = sinon.stub(command, '_stream')
    const spy2 = sinon.stub(command, '_preProcess', opts => {
      return command._process(
          Object.assign(opts, { config: {}, credentials: fakeCredentials }))
    })
    command.run(['node', `${BIN_DIR}/sphere-import`,
      '-p', 'foo', '-t', 'discount', '-f', './foo.json'])
    command.program.project.should.be.equal('foo')
    command.program.type.should.be.equal('discount')
    command.program.from.should.be.equal('./foo.json')
    expect(spy1.args[0][0]).toEqual({
      project: 'foo',
      type: 'discount',
      from: './foo.json',
      batch: 5,
      config: {},
      credentials: fakeCredentials
    })
    expect(spy1.args[0][1]).toBe('discounts.*')
    expect(spy1.args[0].length).toBe(4)
    expect(spy2.calledOnce).toBe(true)
  })
})
