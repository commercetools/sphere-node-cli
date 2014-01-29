'use strict'

sphere_node_cli = require('../lib/sphere.js')

describe 'Awesome', ->

  beforeEach (done)->
    # setup here
    done()

  it 'should print', ->
    expect(sphere_node_cli.awesome()).toBe 'awesome'
