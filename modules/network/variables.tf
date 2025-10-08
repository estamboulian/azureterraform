variable "resource_group_name" {}
variable "location" {}

variable "subnets" {
  type = list(object({
    name   = string
    prefix = string
  }))
}
