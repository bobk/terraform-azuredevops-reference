Feature: verify proper use of resource tagging

Scenario: all resources must have tags
    Given I have resource that supports tags defined
    Then it must contain tags
    And its value must not be null

Scenario Outline: specific tags must be defined
    Given I have resource that supports tags defined
    When it has tags
    Then it must contain <tags>
    And its value must match the "<value>" regex

    Examples:
      | tags        | value                    |
      | costcenter  | ^[0-9]+$                 |
      | environment | ^(dev\|test\|uat\|prod)$ |      
