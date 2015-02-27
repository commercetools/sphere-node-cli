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

  Scenario: Show missing option error
    When I run `sphere import`
    Then the exit status should be 1
    Then the output should contain:
      """
      error:   Missing required options: type
      """
