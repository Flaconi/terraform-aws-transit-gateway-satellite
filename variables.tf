variable "satellite_create" {
  description = "Boolean flag for toggling the handling of satellite resources"
  default     = false
  type        = bool
}

variable "destination_cidr_block" {
  description = "CIDR to be routed"
  default     = ""
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
  description = "IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ENG-OPS)"
  type        = string
  default     = ""
}

variable "role_to_assume_hub" {
  description = "IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ENG-OPS)"
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
}
