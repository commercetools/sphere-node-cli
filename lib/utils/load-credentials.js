import _debug from 'debug'
import { ProjectCredentialsConfig } from 'sphere-node-utils'
import { isTest } from './env'
import pick from './pick'

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
export default function loadCredentials (projectKey, accessToken) {
  if (isTest) return Promise.resolve({ project_key: 'test' })
  if (projectKey && accessToken)
    return Promise.resolve({
      project_key: projectKey,
    })
  if (!projectKey && accessToken) {
    const osVar = pick(process.env, 'SPHERE_PROJECT_KEY')
    if (!osVar) {
      const errorMessage = 'Could not find SPHERE_PROJECT_KEY as ENV variables'
      return Promise.reject(new Error(errorMessage))
    }

    return Promise.resolve({
      project_key: osVar.SPHERE_PROJECT_KEY,
    })
  }
  if (projectKey) {
    debug('lookup project %s from files', projectKey)
    // TODO: maybe make it configurable to provide name / lookup location?
    return ProjectCredentialsConfig.create()
      .then(config => Promise.resolve(config.forProjectKey(projectKey)))
  }

  const osVars = pick(
    process.env,
    'SPHERE_PROJECT_KEY', 'SPHERE_CLIENT_ID', 'SPHERE_CLIENT_SECRET',
  )
  // Fetch values in the Object, simple shim for Object.values
  const osVarsValues = Object.keys(osVars).map(key => osVars[key])
  if (osVarsValues.length === 3) {
    debug('lookup from ENV variables')
    return Promise.resolve({
      project_key: osVars.SPHERE_PROJECT_KEY,
      client_id: osVars.SPHERE_CLIENT_ID,
      client_secret: osVars.SPHERE_CLIENT_SECRET,
    })
  }
  const errorMessage = 'Could not find credentials as ENV variables'
  return Promise.reject(new Error(errorMessage))
}
