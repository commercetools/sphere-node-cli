import sinon from 'sinon'
import test from 'tape'
import Command from '../../lib/utils/command'

function before () {
  return Promise.resolve(new Command())
}

test(`Command
  should throw when calling run`, (t) => {
  before().then((command) => {
    t.throws((() => command.run()), 'Base run method must be overridden')
    t.end()
  })
})

test(`Command
  should throw when calling _process`, (t) => {
  before().then((command) => {
    t.throws(
      (() => command._process()),
      'Base _process method must be overridden',
    )
    t.end()
  })
})

test(`Command
  should validate options`, (t) => {
  before().then((command) => {
    const spy = sinon.stub(command, '_die')
    command._validateOptions({ foo: 'bar' }, 'type')
    t.equal(
      spy.args[0][0],
      'Missing required options: type',
      'Missing required options is reported',
    )
    t.end()
  })
})

test(`Command
  should load credentials and call _process`, (t) => {
  before().then((command) => {
    let interval

    const spy = sinon.stub(command, '_process')
    command._preProcess({ foo: 'bar', project: 'test' })

    function checkCall () {
      if (spy.callCount === 1) {
        t.deepEqual(spy.args[0][0], {
          foo: 'bar',
          project: 'test',
          config: {},
          credentials: {
            project_key: 'test',
          },
        }, 'All credentials are loaded')
        clearInterval(interval)
        t.end()
      }
    }

    // since _preProcess executes a promise we need to check
    // the call in a async way
    // (haven't found a better way to do it)
    interval = setInterval(checkCall, 100)
  })
})

test(`Command
  should parse config`, (t) => {
  before().then((command) => {
    command._parseConfig(JSON.stringify({ foo: 'bar' }))
      .then((config) => {
        t.deepEqual(config, { foo: 'bar' }, 'Config object is parsed')
        t.end()
      })
      .catch(t.end)
  })
})

test(`Command
  should resolve if config option is not provided`, (t) => {
  before().then((command) => {
    command._parseConfig()
      .then((config) => {
        t.deepEqual(
          config,
          {},
          '_parseConfig method returns empty object when no config is parsed',
        )
        t.end()
      })
      .catch(t.end)
  })
})

test(`Command
  should throw if config cannot be parsed`, (t) => {
  before().then((command) => {
    const spy = sinon.stub(command, '_die')
    command._parseConfig('foo=bar')
    t.equal(
      spy.args[0][0],
      'Cannot parse config',
      'Returns error when config cannot be parsed',
    )
    t.equal(spy.args[0].length, 2, 'Error and error stack trace is returns')
    t.end()
  })
})
