/* eslint-disable new-cap */
import fs from 'fs'
/* eslint-disable import/no-extraneous-dependencies */
import mkdirp from 'mkdirp'
import rimraf from 'rimraf'
/* eslint-enable import/no-extraneous-dependencies */
import { OAuth2 } from 'sphere-node-sdk'
import { exec } from 'child_process'
/* eslint-disable import/no-extraneous-dependencies */
import { Given, When, Then } from 'cucumber'
import loadCredentials from './../../lib/utils/load-credentials'

let cleansingNeeded = true
let idCounter = 0
let lastRunSequence = {}
const baseDir = fs.realpathSync(`${__dirname}/../..`)
const tmpDir = `${baseDir}/tmp`
mkdirp(tmpDir)

function uniqueId (prefix) {
  const id = `${idCounter}`
  idCounter += 1
  return `${prefix + id}${new Date().getTime()}_`
}

function joinPathSegments (segments) {
  return segments.join('/')
}

function cleanseIfNeeded () {
  if (cleansingNeeded) {
    try {
      rimraf.sync(tmpDir)
    } catch (e) {} // eslint-disable-line no-empty
    cleansingNeeded = false
  }
}

function normalizeText (text) {
  return text
    // .replace(/\033\[[0-9;]*m/g, '')
    .replace(/\r\n|\r/g, '\n')
    .replace(/^\s+/g, '')
    .replace(/\s+$/g, '')
    .replace(/[ \t]+\n/g, '\n')
}

function getAdditionalErrorText (lastRun) {
  return `Additional error:\n'${lastRun.error}'.\n` +
    `stderr:\n'${lastRun.stderr}'.`
}

Given(
  /^a file named "(.*)" with:$/,
  (filePath, fileContent, callback) => {
    cleanseIfNeeded()
    const absoluteFilePath = `${tmpDir}/${filePath}`
    const filePathSegments = absoluteFilePath.split('/')
    filePathSegments.pop()
    const dirName = joinPathSegments(filePathSegments)

    // replace placeholder for generate unique ids
    const replacedFileContent = fileContent
      .replace(/<id-(\w)>/gi, (match, g1) => uniqueId(g1))

    mkdirp(dirName, (err1) => {
      if (err1) throw new Error(err1)

      fs.writeFile(absoluteFilePath, replacedFileContent, (err2) => {
        if (err2) throw new Error(err2)
        callback()
      })
    })
  },
)


When(/^I run `sphere(| .+)`$/, (args, callback) => {
  const initialCwd = process.cwd()
  process.chdir(tmpDir)

  const runtimePath = joinPathSegments([ baseDir, 'bin', 'sphere' ])
  const command = runtimePath + args
  exec(command, (error, stdout, stderr) => {
    lastRunSequence = { error, stdout, stderr }
    process.chdir(initialCwd)
    cleansingNeeded = true
    callback()
  })
})

When(
  /^I run with accessToken `sphere(| .+)`$/,
  { timeout: 60 * 1000 },
  (args, callback) => {
    loadCredentials().then((credentials) => {
      const oauth2 = new OAuth2({ config: credentials })
      oauth2.getAccessToken((err, response, body) => {
        if (err)
          throw new Error(`Error occurred when fetching accessToken ${err}`)
        const accessToken = body.access_token
        const initialCwd = process.cwd()
        process.chdir(tmpDir)

        const runtimePath = joinPathSegments([ baseDir, 'bin', 'sphere' ])
        const command = `${runtimePath} ${args} --accessToken ${accessToken}`
        const env = Object.assign({}, process.env, {
          SPHERE_CLIENT_ID: undefined,
          SPHERE_CLIENT_SECRET: undefined,
        })
        const options = { env }
        exec(command, options, (error, stdout, stderr) => {
          lastRunSequence = { error, stdout, stderr }
          process.chdir(initialCwd)
          cleansingNeeded = true
          callback()
        })
      })
    })
  },
)

Then(/^the exit status should be ([0-9]+)$/, (code, callback) => {
  const actualCode = lastRunSequence.error ? lastRunSequence.error.code : '0'

  if (`${actualCode}` !== `${code}`)
    throw new Error(`Exit code expected: '${code}\n
                    Got: '${actualCode}'\n
                    ${getAdditionalErrorText(lastRunSequence)}`)
  callback()
})

Then(/^the output should contain:$/, (expectedOutput, callback) => {
  const actualOutput = normalizeText(lastRunSequence.error ?
    lastRunSequence.stderr : lastRunSequence.stdout)
  const normalizedExpectedOutput = normalizeText(expectedOutput)

  if (actualOutput.indexOf(normalizedExpectedOutput) < 0)
    throw new Error(`Expected output to match the following:\n
                    '${normalizedExpectedOutput}'\n
                    Got:\n'${actualOutput}'.\n
                    ${getAdditionalErrorText(lastRunSequence)}`)
  callback()
})

Then(/^the output should be a version number$/, (callback) => {
  const actualOutput = normalizeText(lastRunSequence.stdout)

  if (!new RegExp(/\d+\.\d+\.\d+/).test(actualOutput))
    throw new Error(`Expected output to be a version number:\n
                    Got:\n'${actualOutput}'.\n
                    ${getAdditionalErrorText(lastRunSequence)}`)
  callback()
})
