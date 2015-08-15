Feature: CLI - Export command

  Scenario: Show command help
    When I run `sphere help export`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere-export
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
      -o, --output <path>
      """
    Then the output should contain:
      """
      --pretty
      """

  Scenario: Show missing option error
    When I run `sphere export`
    Then the exit status should be 1
    Then the output should contain:
      """
      Missing required options: type
      """

  Scenario: Show error if cannot lookup credentials for a project key
    When I run `sphere export -p foo -t product`
    Then the exit status should be 1
    Then the output should contain:
      """
      Can't find credentials for project 'foo'
      """

  Scenario: Export products by writing to a file
    When I run `sphere export -t product -o tmp/export.json`
    Then the exit status should be 0
    Then the output should contain:
      """
      Output written to export.json
      """
