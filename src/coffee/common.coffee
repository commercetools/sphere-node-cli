module.exports = class

  @logError: (error) =>
    @log error
    @die 1

  @log: ->
    unless process.env.NODE_ENV is 'test'
      console.log.apply null, Array::slice.call arguments

  @die: (code) ->
    process.exit(code or 0)
