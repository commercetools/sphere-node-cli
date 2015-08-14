import _debug from 'debug'
import _ from 'underscore'
import { ProjectCredentialsConfig } from 'sphere-node-utils'

const debug = _debug('sphere-credentials')

/**
 * Try to load credentials from pre-defined locations,
 * based on the `projectKey`
 *
 * @param {string} projectKey
 *
 * Lookup priority:
 * - ./.sphere-project-credentials
 * - ./.sphere-project-credentials.json
 * - ~/.sphere-project-credentials
 * - ~/.sphere-project-credentials.json
 * - /etc/sphere-project-credentials
 * - /etc/sphere-project-credentials.json
 * Otherwise look up from OS env
 */
export function load (projectKey) {
  if (projectKey) {
    debug('lookup project %s from files', projectKey)
    // TODO: maybe make it configurable to provide name / lookup location?
    return ProjectCredentialsConfig.create()
    .then(config => Promise.resolve(config.forProjectKey(projectKey)))
  }

  const osVars = _.pick(process.env,
    'SPHERE_PROJECT_KEY', 'SPHERE_CLIENT_ID', 'SPHERE_CLIENT_SECRET')

  if (Object.values(osVars).length === 3) {
    debug('lookup from ENV variables')
    return Promise.resolve({
      project_key: osVars.SPHERE_PROJECT_KEY,
      client_id: osVars.SPHERE_CLIENT_ID,
      client_secret: osVars.SPHERE_CLIENT_SECRET
    })
  }

  return Promise.reject('Could not find credentials as ENV variables')
}
