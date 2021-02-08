variable "location" {
  type    = string
  default = "eastus"
}

variable "suffix" {
  type    = string
  default = "reference"
}

variable "tags" {
  type = map

  default = {
    environment = "dev"
    costcenter = "1234"
  }
}
