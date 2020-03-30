# The Transit Gateway (hub) has already been created in AWS, as a fixture for
# this test case due to not being able to use 'depends_on' on Terraform modules
module "tgw-satellite" {
  source = "../../"

  providers = {
    aws.satellite = aws.satellite
    aws.hub       = aws.hub
  }

  aws_login_profile = var.aws_login_profile
  satellite_create  = var.satellite_create

  aws_account_id_hub       = var.aws_account_id_hub
  aws_account_id_satellite = local.aws_account_id_satellite

  role_to_assume_hub       = var.role_to_assume_hub
  role_to_assume_satellite = var.role_to_assume_satellite

  vpc_name_to_attach     = var.vpc_name_to_attach
  destination_cidr_block = var.destination_cidr_block

  subnet_name_keyword_selector = var.subnet_name_keyword_selector

  transit_gateway_hub_name = var.transit_gateway_hub_name
}
