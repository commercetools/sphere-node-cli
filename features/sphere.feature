Feature: CLI

  Scenario: Show general help
    When I run `sphere`
    Then the exit status should be 0
    Then the output should contain:
      """
      Usage: sphere
      """
