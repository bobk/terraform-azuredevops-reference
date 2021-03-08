# terraform-azuredevops-reference

### Abstract

This is a reference example of a complete Azure DevOps CI cycle for Terraform using a selection of known vendor and OSS tools. This example demonstrates how to perform static analysis, integration testing, compliance testing and end-to-end testing. For background information, please see this article on the Microsoft Azure Terraform site:

https://docs.microsoft.com/en-us/azure/developer/terraform/best-practices-testing-overview

### Toolset

* Terraform
   * init, validate, plan, show, apply
* Terratest 
   * terratest_log_parser, Go, Azure SDK For Go, Terratest Azure Module
* Checkov
   * configurable static analysis for Terraform HCL
* terraform-compliance
   * simple BDD testing
   * via both local install and Docker container
* Azure DevOps 
   * azure-pipelines.yaml, various yaml settings, test results publishing

### Prerequisites

* Create a storage account and container in the desired resource group. Ensure all public access to the storage account and container is off.

   az storage account create /\
      --name YOURSTORAGEACCOUNTNAME /\
      --resource-group YOURRESOURCEGROUPNAME /\
      --kind StorageV2 /\
      --sku Standard_LRS /\
      --https-only true /\
      --allow-blob-public-access false

   az storage container create /\
      --name YOURSTORAGECONTAINERNAME /\
      --account-name YOURSTORAGEACCOUNTNAME /\
      --public-access off /\
      --auth-mode login

* Fork the repo and update tf/core/src/main.tf to the appropriate storage account values above. Use any blob key name you want.

* Create a service principal with Contributor role on the above storage account YOURSTORAGEACCOUNTNAME and on the resource group YOURRESOURCEGROUPNAME.

* Create library variables in your Azure DevOps project (be sure to mark them secret):

   ARM_CLIENT_ID: yourclientid
   ARM_CLIENT_SECRET: yourclientsecret
   ARM_SUBSCRIPTION_ID: yoursubscriptionid
   ARM_TENANT_ID: yourtenantid

* Create a new pipeline against the repo. This reference example should install easily as a Azure DevOps pipeline and pass/warn all tests. Note that the pipeline YAML files are in a subdirectory /azure-pipelines.

### Resources Created

| Resource Group | Resource Name | Resource Type |
|:--|:--|:--|
| | | |
| | | | 

### Build Status

[![Build Status](https://dev.azure.com/krcloud1/terraform/_apis/build/status/bobk.terraform-azuredevops-reference?branchName=main)](https://dev.azure.com/krcloud1/terraform/_build/latest?definitionId=12&branchName=main)
