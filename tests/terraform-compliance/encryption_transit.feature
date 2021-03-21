Feature: verify proper use of encryption for data in transit

Scenario: storage accounts must use encrypted network connections
    Given I have azurerm_storage_account defined
    Then it must contain enable_https_traffic_only
    And its value must be true

Scenario: storage accounts must use proper TLS version(s) for encrypted network connections
    Given I have azurerm_storage_account defined
    Then it must contain min_tls_version
    And its value must be "TLS1_2"
