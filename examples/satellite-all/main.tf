module "tgw" {
  source = "github.com/flaconi/terraform-aws-transit-gateway-hub.git?ref=v1.6.0"

  providers = {
    aws = aws.hub
  }

  name = var.transit_gateway_hub_name

  aws_account_id_hub       = var.aws_account_id_hub
  aws_account_id_satellite = [var.aws_account_id_satellite]
}

module "tgw-satellite-all" {
  source = "../../"

  providers = {
    aws.satellite = aws.satellite
    aws.hub       = aws.hub
  }

  satellite_create = var.satellite_create

  aws_account_id_hub       = var.aws_account_id_hub
  aws_account_id_satellite = var.aws_account_id_satellite

  vpc_name_to_attach = var.vpc_name_to_attach

  satellite_destination_cidr_blocks = var.satellite_destination_cidr_blocks
  hub_destination_cidr_blocks       = var.hub_destination_cidr_blocks

  attachment_subnet_filters = var.attachment_subnet_filters

  transit_gateway_hub_name = var.transit_gateway_hub_name

  route_entire_satellite_vpc = var.route_entire_satellite_vpc

  route_private_subnets_via_tgw = var.route_private_subnets_via_tgw

  private_subnet_filters = var.private_subnet_filters

  depends_on = [module.tgw]
}
