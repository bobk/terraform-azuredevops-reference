variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "tags" {
  type = map
}

variable "la_sku" {
  type = string
  default = "PerGB2018"
}

variable "la_retention_in_days" {
  type = number
  default = 30
}

variable "lalsa_ids" {
  type = list(string)
}
