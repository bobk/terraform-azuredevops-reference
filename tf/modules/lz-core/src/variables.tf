variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "tags" {
  type = map
}

variable "sa_account_tier" {
  type = string
  default = "Standard"
}

variable "sa_account_replication_type" {
  type = string
  default = "GRS"
}

variable "kv_sku_name" {
  type = string
  default = "standard"
}
