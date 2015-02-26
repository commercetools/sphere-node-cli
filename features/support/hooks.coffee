module.exports = ->

  @Before (callback) ->
    # TODO: prepare environment
    # - cleanup
    # - credentials

    callback()

  @After (callback) ->
    # TODO: cleanup environment

    callback()
