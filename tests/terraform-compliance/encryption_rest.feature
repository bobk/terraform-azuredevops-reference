Feature: verify proper use of encryption for data at rest

Scenario: key vaults must support Disk Encryption requests
    Given I have azurerm_key_vault defined
    Then it must contain enabled_for_disk_encryption
    And its value must be true

Scenario: managed disks must have encryption enabled
    Given I have azurerm_managed_disk defined
    Then it must contain encryption_settings
    And it must contain enabled
    And its value must be true
