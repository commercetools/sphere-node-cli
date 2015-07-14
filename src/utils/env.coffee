pkg = require '../../package.json'

exports.ENV = process.env.NODE_ENV
exports.HOME = process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE

exports.USER_AGENT = "#{pkg.name} - #{pkg.version}"
