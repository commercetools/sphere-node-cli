_ = require('underscore')

module.exports = class

  @logError: (error)=>
    @log error
    @die 1

  @log: ->
    console.log.apply null, Array::slice.call arguments

  @die: (code)->
    process.exit(code or 0)
