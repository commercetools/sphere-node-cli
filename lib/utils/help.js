/* eslint-disable no-console, max-len */
export default function help () {
  console.log(`
${'  '}Credentials:
${''}
${'    '}The CLI has a lookup mechanism to load SPHERE.IO project credentials.
${'    '}If you specify a `-p, --project` option, the CLI will try to load the
${'    '}credentials for that project from the following locations:
${''}
${'      '}./.sphere-project-credentials
${'      '}./.sphere-project-credentials.json
${'      '}~/.sphere-project-credentials
${'      '}~/.sphere-project-credentials.json
${'      '}/etc/sphere-project-credentials
${'      '}/etc/sphere-project-credentials.json
${''}
${'    '}Supported files format (CSV, JSON)
${''}
${'      '}CSV    project_key:client_id:client_secret
${'      '}JSON   { "project_key": { "client_id": "", "client_secret": "" } }
${''}
${'    '}If no project key is provided, the CLI tries to read the credentials from ENV variables:
${''}
${'      '}export SPHERE_PROJECT_KEY=""
${'      '}export SPHERE_CLIENT_ID=""
${'      '}export SPHERE_CLIENT_SECRET=""
${''}
${''}
  `)
}
