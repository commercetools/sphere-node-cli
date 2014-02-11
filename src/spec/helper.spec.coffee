helper = require('../lib/helper')

describe 'Helper', ->

  it 'should export \'ROOT\'', ->
    expect(helper.ROOT).toBeDefined()

  it 'should export \'ROOT_FOLDER\'', ->
    expect(helper.ROOT_FOLDER).toMatch /\/.sphere-cli/

  it 'should export \'PATH_TO_CREDENTIALS\'', ->
    expect(helper.PATH_TO_CREDENTIALS).toMatch /\/.sphere-cli\/credentials-test\.json/

  it 'should export nconf', ->
    expect(helper.nconf.stores.file.file).toMatch /\/.sphere-cli\/credentials-test\.json/
