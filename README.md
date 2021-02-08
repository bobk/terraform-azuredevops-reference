# terraform-azuredevops-reference

This is a reference example of a complete Azure DevOps CI cycle for Terraform using a selection of known tools:

* Terraform
   * init, validate, plan, apply
* Terratest 
   * terratest_log_parser, GO, Azure SDK For Go, Terratest Azure Module
* Checkov
   * configurable static analysis for Terraform HCL
* terraform-compliance
   * simple BDD testing
* Azure DevOps 
   * azure-pipelines.yaml, various yaml settings, test results publishing

This reference example should install as a Azure DevOps pipeline and pass all tests.

Additional expanded documentation will be available shortly.

