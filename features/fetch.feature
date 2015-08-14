Feature: CLI - Fetch command

  Scenario: Show command help
    When I run `sphere help fetch`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere-fetch
      """
    Then the output should contain:
      """
      -p, --project <key>
      """
    Then the output should contain:
      """
      -t, --type <name>
      """

  Scenario: Show missing option error
    When I run `sphere fetch`
    Then the exit status should be 1
    Then the output should contain:
      """
      Missing required options: type
      """

  Scenario: Show error if cannot lookup credentials for a project key
    When I run `sphere fetch -p foo -t product`
    Then the exit status should be 1
    Then the output should contain:
      """
      Can't find credentials for project 'foo'
      """

  Scenario: Fetch products
    When I run `sphere fetch -t product`
    Then the exit status should be 0
    Then the output should contain:
      """
      "statusCode":200,"body"
      """
