import sinon from 'sinon'
import expect from 'expect'
import Command from '../../lib/utils/command'

describe('Command', () => {
  let command

  beforeEach(() => {
    command = new Command()
  })

  it('should throw when calling run', () => {
    expect(() => command.run())
      .toThrow('Base run method must be overridden')
  })

  it('should throw when calling _process', () => {
    expect(() => command._process())
      .toThrow('Base _process method must be overridden')
  })

  it('should validate options', () => {
    const spy = sinon.stub(command, '_die')
    command._validateOptions({ foo: 'bar' }, 'type')
    expect(spy.args[0][0]).toEqual('Missing required options: type')
  })

  it('should load credentials and call _process', done => {
    let interval

    const spy = sinon.stub(command, '_process')
    command._preProcess({ foo: 'bar', project: 'test' })

    function checkCall () {
      if (spy.callCount === 1) {
        expect(spy.args[0][0]).toEqual({
          foo: 'bar',
          project: 'test',
          config: {},
          credentials: {
            project_key: 'test'
          }
        })
        clearInterval(interval)
        done()
      }
    }

    // since _preProcess executes a promise we need to check
    // the call in a async way
    // (haven't found a better way to do it)
    interval = setInterval(checkCall, 100)
  })

  it('should parse config', done => {
    command._parseConfig(JSON.stringify({ foo: 'bar' }))
    .then(config => {
      expect(config).toEqual({ foo: 'bar' })
      done()
    })
    .catch(done)
  })

  it('should resolve if config option is not provided', done => {
    command._parseConfig()
    .then(config => {
      expect(config).toEqual({})
      done()
    })
    .catch(done)
  })

  it('should throw if config cannot be parsed', () => {
    const spy = sinon.stub(command, '_die')
    command._parseConfig('foo=bar')
    expect(spy.args[0][0]).toEqual('Cannot parse config')
    expect(spy.args[0].length).toBe(2)
  })
})
