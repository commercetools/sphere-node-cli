Feature: CLI

  Scenario: Show general help
    When I run `sphere`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere
      """
    Then the output should contain:
      """
      import
      """
    Then the output should contain:
      """
      fetch
      """

    When I run `sphere -h`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere
      """

  Scenario: Show version
    When I run `sphere -V`
    Then the exit status should be 0
    Then the output should be a version number
