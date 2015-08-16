Feature: CLI - Import command

  Scenario: Show command help
    When I run `sphere help import`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere-import
      """
    Then the output should contain:
      """
      -p, --project <key>
      """
    Then the output should contain:
      """
      -t, --type <name>
      """
    Then the output should contain:
      """
      -f, --from <path>
      """
    Then the output should contain:
      """
      -b, --batch <n>
      """
    Then the output should contain:
      """
      -c, --config <object>
      """

  Scenario: Show missing option error
    When I run `sphere import -p foo`
    Then the exit status should be 1
    Then the output should contain:
      """
      Missing required options: type
      """

  Scenario: Show error if cannot lookup credentials for a project key
    When I run `sphere import -p foo -t stock`
    Then the exit status should be 1
    Then the output should contain:
      """
      Can't find credentials for project 'foo'
      """

  Scenario: Show error if cannot parse config
    When I run `sphere import -t stock -c 'foo=bar'`
    Then the exit status should be 1
    Then the output should contain:
      """
      Cannot parse config SyntaxError: Unexpected token o
      """

  Scenario: Import stock by reading file as stream
    Given a file named "stocks.json" with:
      """
      {
        "stocks": [
          {
            "sku": "<id-a>",
            "quantityOnStock": 10
          },
          {
            "sku": "<id-b>",
            "quantityOnStock": 20
          }
        ]
      }
      """
    When I run `sphere import -t stock -f stocks.json`
    Then the exit status should be 0
    Then the output should contain:
      """
      Summary: there were 2 imported stocks (2 were new and 0 were updates)
      """

  Scenario: Show error if chunk cannot be parsed as JSON
    Given a file named "stocks.json" with:
      """
      {
        "foo:
      }
      """
    When I run `sphere import -t stock -f stocks.json`
    Then the exit status should be 1
    Then the output should contain:
      """
      Cannot parse chunk as JSON.
      """
