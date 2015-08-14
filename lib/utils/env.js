import pkg from '../../package.json'

export const ENV = process.env.NODE_ENV
export const HOME = process.env.HOME
  || process.env.HOMEPATH
  || process.env.USERPROFILE

export const USER_AGENT = `${pkg.name} - ${pkg.version}`
