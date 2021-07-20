variable "resource_group_name" {
}
variable "location" {
}
variable "prefix" {
}
variable "kind" {
}
variable "custom_subdomain" {
}
variable "allowed_fqdns" {
  type = list(string)
}
variable "private_endpoint_subnet_id" {
}
# variable "private_link_dns_zones" {
#   type = map(string)
# }
