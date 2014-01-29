# References

- sphere CLI (ruby) output, for reference

```
NAME
    sphere - A sphere CLI tool

SYNOPSIS
    sphere [global options] command [command options] [arguments...]

VERSION
    0.6.8

GLOBAL OPTIONS
    -u, --user=email      - The username to use. (default: none)
    -p, --password=passwd - The password to use. (default: none)
    -s, --mc-server=url   - Use specified MC server instead of the default one. (default: https://admin.sphere.io)
    -w, --www-server=url  - Use specified WWW server instead of the default one. (default: http://sphere.io)
    --config=file         - Config file to use. (default: ["/etc/sphere/config.yaml", "~/.sphere.yaml",
                            ".sphere.yaml"])
    --version             - Shows version information about this tool
    -q, --quiet           - Enable quiet mode
    -v, --verbose         - Enable verbose mode
    -d, --debug           - Enable debug mode
    -f, --force           - Use force, do not ask for confirmations on destructive actions
    -i, --ignore-ssl      - Do not check for SSL certificates
    -j, --json-pretty     - Output in pretty-printed JSON
    -J, --json-raw        - Output in raw JSON
    --help                - Show this message

COMMANDS
    help                 - Shows a list of commands or help for one command
    account              - Sphere account management
    login                - Log in with a sphere user account
    logout               - Log out the currently logged-in user
    signup               - Sign up for a new sphere account
    category, categories - Manage categories of a project
    code                 - Manage the source code of your applications
    type, types          - Manage product types in a project
    product, products    - Manage products for a project
    project, projects    - Manage sphere projects
    tax, taxes           - Manage taxes in your project
```