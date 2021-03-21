# in what Azure location should the resources be created
variable "location" {
  type    = string
  default = "eastus"
}

# what suffix should be used for the resource and resource group names
variable "suffix" {
  type    = string
  default = "reference"
}

# these are test tags for the BDD testing
variable "tags" {
  type = map(any)

  default = {
    environment = "dev"
    costcenter  = "1234"
  }
}
