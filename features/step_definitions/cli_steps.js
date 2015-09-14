/* eslint-disable new-cap */
import fs from 'fs'
import mkdirp from 'mkdirp'
import rimraf from 'rimraf'
import { exec } from 'child_process'

export default function cliSteps () {
  let cleansingNeeded = true
  let idCounter = 0
  const baseDir = fs.realpathSync(`${__dirname}/../..`)
  const tmpDir = `${baseDir}/tmp`
  mkdirp(tmpDir)

  function uniqueId (prefix) {
    const id = `${++idCounter}`
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

  this.Given(/^a file named "(.*)" with:$/,
    (filePath, fileContent, callback) => {
      cleanseIfNeeded()
      const absoluteFilePath = `${tmpDir}/${filePath}`
      const filePathSegments = absoluteFilePath.split('/')
      filePathSegments.pop()
      const dirName = joinPathSegments(filePathSegments)

      // replace placeholder for generate unique ids
      const replacedFileContent = fileContent
        .replace(/\<id\-(\w)\>/gi, (match, g1) => uniqueId(g1))

      mkdirp(dirName, err1 => {
        if (err1) throw new Error(err1)

        fs.writeFile(absoluteFilePath, replacedFileContent, err2 => {
          if (err2) throw new Error(err2)
          callback()
        })
      })
    })

  this.When(/^I run `sphere(| .+)`$/, (args, callback) => {
    const initialCwd = process.cwd()
    process.chdir(tmpDir)

    const runtimePath = joinPathSegments([ baseDir, 'bin', 'sphere' ])
    const command = runtimePath + args
    exec(command, (error, stdout, stderr) => {
      this.lastRun = { error, stdout, stderr }
      process.chdir(initialCwd)
      cleansingNeeded = true
      callback()
    })
  })

  this.Then(/^the exit status should be ([0-9]+)$/, (code, callback) => {
    const actualCode = this.lastRun.error ? this.lastRun.error.code : '0'

    if (`${actualCode}` !== `${code}`)
      throw new Error(`Exit code expected: \"${code}\"\n` +
                      `Got: \"${actualCode}\"\n` +
                      getAdditionalErrorText(this.lastRun))
    callback()
  })

  this.Then(/^the output should contain:$/, (expectedOutput, callback) => {
    const actualOutput = normalizeText(this.lastRun.error ?
      this.lastRun.stderr : this.lastRun.stdout)
    const normalizedExpectedOutput = normalizeText(expectedOutput)

    if (actualOutput.indexOf(normalizedExpectedOutput) < 0)
      throw new Error(`Expected output to match the following:\n` +
                      `'${normalizedExpectedOutput}'\n` +
                      `Got:\n'${actualOutput}'.\n` +
                      getAdditionalErrorText(this.lastRun))
    callback()
  })

  this.Then(/^the output should be a version number$/, callback => {
    const actualOutput = normalizeText(this.lastRun.stdout)

    if (!new RegExp(/\d\.\d\.\d/).test(actualOutput))
      throw new Error(`Expected output to match the following:\n` +
                      `'${expectedOutput}'\n` +
                      `Got:\n'${actualOutput}'.\n` +
                      getAdditionalErrorText(this.lastRun))
    callback()
  })
}
