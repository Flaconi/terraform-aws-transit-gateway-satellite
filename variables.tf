variable "satellite_create" {
  description = "Boolean flag for toggling the handling of satellite resources"
  default     = false
  type        = bool
}

variable "satellite_destination_cidr_blocks" {
  description = "List of CIDRs to be routed for the satellite"
  type        = list
  default     = []
}

variable "hub_destination_cidr_blocks" {
  description = "List of CIDRs to be routed for the hub"
  type        = list
  default     = []
}

variable "aws_account_id_satellite" {
  description = "AWS account number containing the TGW satellite"
  type        = string
  default     = ""
}

variable "aws_account_id_hub" {
  description = "AWS account number containing the TGW hub"
  type        = string
}

variable "aws_login_profile" {
  description = "Name of the AWS login profile as seen under ~/.aws/config used for assuming cross-account roles"
}

variable "role_to_assume_satellite" {
  description = "IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ROLE-SATELLITE)"
  type        = string
  default     = ""
}

variable "role_to_assume_hub" {
  description = "IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ROLE-HUB)"
  type        = string
}

variable "vpc_name_to_attach" {
  description = "Name of the satellite VPC to be attached to the TGW"
  type        = string
  default     = ""
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of the Transit Gateway Route Table"
  type        = string
  default     = ""
}

variable "transit_gateway_id" {
  description = "Identifier of the Transit Gateway"
  type        = string
  default     = ""
}

variable "ram_resource_association_id" {
  description = "Identifier of the Resource Access Manager Resource Association"
  type        = string
  default     = ""
}

variable "subnet_filters" {
  description = "List of maps selecting the subnet(s) for which the routing will be added"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = [
    {
      name   = "tag:Name"
      values = ["private"]
    }
  ]
}

variable "transit_gateway_hub_name" {
  description = "Name of the Transit Gateway to attach to"
  type        = string
  default     = ""
}

variable "route_entire_satellite_vpc" {
  description = "Boolean flag for toggling the creation of network routes for all the subnets of the satellite VPC"
  type        = bool
  default     = false
}

variable "transit_gateway_default_route_table_association" {
  description = "Set this to false when the hub account also becomes a satellite. Check the official docs for more info."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Set this to false when the hub account also becomes a satellite. Check the official docs for more info."
  type        = bool
  default     = true
}
