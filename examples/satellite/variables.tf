variable "satellite_create" {
  description = "Boolean flag for toggling the handling of satellite resources"
  default     = false
  type        = bool
}

variable "aws_login_profile" {
  description = "Name of the AWS login profile as seen under ~/.aws/config used for assuming cross-account roles"
}

variable "aws_account_id_hub" {
  description = "AWS account number containing the TGW hub"
  type        = string
}

variable "aws_account_id_satellite" {
  description = "List of AWS account numbers representing the satellites of the TGW"
  type        = list
}

variable "role_to_assume_hub" {
  description = "IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ROLE-HUB)"
  type        = string
}

variable "role_to_assume_satellite" {
  description = "IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ROLE-SATELLITE)"
  type        = string
}

variable "vpc_name_to_attach" {
  description = "Name of the satellite VPC to be attached to the TGW"
  type        = string
  default     = ""
}

variable "destination_cidr_block" {
  description = "CIDR to be routed"
  default     = ""
}

variable "subnet_name_keyword_selector" {
  description = "Keyword matching the name of the subnet(s) for which the routing will be added (i.e. private)"
  type        = string
  default     = "private"
}

variable "transit_gateway_hub_name" {
  description = "Name of the Transit Gateway to attach to"
  type        = string
  default     = ""
}
