import pkg from '../../package.json'

export const isTest = process.env.NODE_ENV === 'test'
export const homePath = process.env.HOME
  || process.env.HOMEPATH
  || process.env.USERPROFILE

export const userAgent = `${pkg.name} - ${pkg.version}`
