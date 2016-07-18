module.exports = function customStock (options) {
  const processFn = processStream
  return [ options, 'stocks.*', processFn, finishFn ]
}

function processStream (data, next) {
  return new Promise(function (/* resolve, reject */) {
    setTimeout(function () {
      console.log(data)
      next()
    }, 500)
  })
}

function finishFn () {
  return console.log('Finished')
}
