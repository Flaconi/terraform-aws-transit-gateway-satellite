variable "satellite_create" {
  description = "Boolean flag for toggling the handling of satellite resources"
  default     = false
  type        = bool
}

variable "satellite_destination_cidr_blocks" {
  description = "List of CIDRs to be routed for the satellite"
  type        = list(string)
  default     = []
}

variable "hub_destination_cidr_blocks" {
  description = "List of CIDRs to be routed for the hub"
  type        = list(string)
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

variable "attachment_subnet_filters" {
  description = "List of maps selecting the subnet(s) where TGW will be attached"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = [
    {
      name   = "tag:Name"
      values = ["*private*"]
    }
  ]
}

variable "private_subnets_strict_acl_rules" {
  description = "Create additional ACLs for private subnets to restrict inbound traffic only to VPC itself and VPCs paired over TGW"
  type        = bool
  default     = false
}

variable "route_private_subnets_via_tgw" {
  description = "Use TGW attachment as a default route (0.0.0.0/0) for private subnets. Value `satellite_destination_cidr_block`s will be ignored."
  type        = bool
  default     = false
}

variable "private_subnet_filters" {
  description = "List of maps selecting the subnet(s) which are private"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = [
    {
      name   = "tag:Name"
      values = ["*private*"]
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

variable "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled."
  type        = string
  default     = "disable"
}
