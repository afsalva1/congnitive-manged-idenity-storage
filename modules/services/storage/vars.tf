variable "resource_group_name" {}
variable "location" {}
variable "alphanum_prefix" {}
variable "prefix" {}
variable "private_endpoint_subnet_id" {}
variable "private_link_dns_zones" {
  type = map(string)
}
