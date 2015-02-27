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
      Missing required options: type
      """

  Scenario: Import stock by reading file as stream
    Given a file named "stock.json" with:
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
    When I run `sphere import -t stock -f stock.json`
    Then the exit status should be 0
    Then the output should contain:
      """
      Summary: there were 2 imported stocks (2 were new and 0 were updates)
      """
