_ = require 'underscore'
fs = require 'fs'
rimraf = require 'rimraf'
exec = require('child_process').exec
mkdirp = require 'mkdirp'

module.exports = ->

  baseDir         = fs.realpathSync(__dirname + "/../..")
  tmpDir          = "#{baseDir}/tmp"
  cleansingNeeded = true
  mkdirp(tmpDir)

  uniqueId = (prefix) -> _.uniqueId "#{prefix}#{new Date().getTime()}_"

  joinPathSegments = (segments) -> segments.join('/')

  cleanseIfNeeded = ->
    if cleansingNeeded
      try rimraf.sync(tmpDir) catch e # ignore
      cleansingNeeded = false

  normalizeText = (text) ->
    text
    .replace(/\033\[[0-9;]*m/g, '')
    .replace(/\r\n|\r/g, '\n')
    .replace(/^\s+/g, '')
    .replace(/\s+$/g, '')
    .replace(/[ \t]+\n/g, '\n')

  getAdditionalErrorText = (lastRun) ->
    "Additional error:\n'#{lastRun['error']}'.\nstderr:\n'#{lastRun['stderr']}'."

  @Given /^a file named "(.*)" with:$/, (filePath, fileContent, callback) ->

    cleanseIfNeeded()
    absoluteFilePath = "#{tmpDir}/#{filePath}"
    filePathSegments = absoluteFilePath.split('/')
    fileName         = filePathSegments.pop()
    dirName          = joinPathSegments(filePathSegments)

    # replace placeholder for generate unique ids
    fileContent = fileContent.replace(/\<id\-(\w)\>/gi, (match, g1) -> uniqueId(g1))

    mkdirp dirName, (err) ->
      throw new Error(err) if err
      fs.writeFile absoluteFilePath, fileContent, (err) ->
        throw new Error(err) if err
        callback()

  @When /^I run `sphere(| .+)`$/, (args, callback) ->

    initialCwd = process.cwd()
    process.chdir(tmpDir)

    runtimePath = joinPathSegments [baseDir, 'bin', 'sphere']
    command = runtimePath + args
    exec command, (error, stdout, stderr) =>
      @lastRun =
        error:  error
        stdout: stdout
        stderr: stderr
      process.chdir(initialCwd)
      cleansingNeeded = true
      callback()


  @Then /^the exit status should be ([0-9]+)$/, (code, callback) ->

    actualCode = if @lastRun.error then @lastRun.error.code else '0'

    if "#{actualCode}" isnt "#{code}"
      throw new Error "Exit code expected: \"#{code}\"\nGot: \"#{actualCode}\"\n"

    callback()


  @Then /^the output should contain:$/, (expectedOutput, callback) ->

    actualOutput = normalizeText((if @lastRun.error then @lastRun['stderr'] else @lastRun['stdout']))
    expectedOutput = normalizeText(expectedOutput)

    if actualOutput.indexOf(expectedOutput) < 0
      throw new Error "Expected output to match the following:\n'#{expectedOutput}'\n" +
                      "Got:\n'#{actualOutput}'.\n" + getAdditionalErrorText(@lastRun)

    callback()


  @Then /^the output should be a version number$/, (callback) ->

    actualOutput = normalizeText(@lastRun['stdout'])

    unless new RegExp(/\d\.\d\.\d/).test(actualOutput)
      throw new Error "Expected output to match the following:\n'#{expectedOutput}'\n" +
                      "Got:\n'#{actualOutput}'.\n" + getAdditionalErrorText(@lastRun)

    callback()
