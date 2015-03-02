debug = require('debug')('sphere-credentials')
_ = require 'underscore'
Promise = require 'bluebird'
{ProjectCredentialsConfig} = require 'sphere-node-utils'
{ENV} = require './env'

module.exports =

  # Lookup credentials with given project key
  # - ./.sphere-project-credentials
  # - ./.sphere-project-credentials.json
  # - ~/.sphere-project-credentials
  # - ~/.sphere-project-credentials.json
  # - /etc/sphere-project-credentials
  # - /etc/sphere-project-credentials.json
  # Otherwise look up from OS env
  load: (projectKey) ->
    if projectKey
      debug 'lookup project %s from files', projectKey
      # TODO: maybe make it configurable to provide name / lookup location?
      ProjectCredentialsConfig.create()
      .then (config) -> Promise.resolve config.forProjectKey(projectKey)
    else
      osVars = _.pick(process.env, 'SPHERE_PROJECT_KEY', 'SPHERE_CLIENT_ID', 'SPHERE_CLIENT_SECRET')
      if _.size(_.values(osVars)) is 3
        debug 'lookup from ENV variables'
        Promise.resolve
          project_key: osVars.SPHERE_PROJECT_KEY
          client_id: osVars.SPHERE_CLIENT_ID
          client_secret: osVars.SPHERE_CLIENT_SECRET
      else
        Promise.reject 'Could not find credentials as ENV variables'
