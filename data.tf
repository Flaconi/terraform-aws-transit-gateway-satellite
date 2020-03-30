data "aws_vpc" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name_to_attach]
  }
}

data "aws_subnet_ids" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  vpc_id   = data.aws_vpc.this[0].id
  tags = {
    Name = "*${var.subnet_name_keyword_selector}*"
  }
}

data "aws_route_table" "this" {
  provider = aws.satellite
  count    = local.create ? length(data.aws_subnet_ids.this[0].ids) : 0

  subnet_id = sort(data.aws_subnet_ids.this[0].ids)[count.index]
}

data "aws_ec2_transit_gateway" "this" {
  provider = aws.hub
  count    = local.create ? 1 : 0

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "owner-id"
    values = [var.aws_account_id_hub]
  }

  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ram_resource_share.this[0].tags.transit-gateway-id]
  }
}

data "aws_ec2_transit_gateway_route_table" "this" {
  provider = aws.hub
  count    = local.create ? 1 : 0

  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.this[0].id]
  }
}

data "aws_ram_resource_share" "this" {
  provider = aws.hub
  count    = local.create ? 1 : 0

  name           = var.transit_gateway_hub_name
  resource_owner = "SELF"
}
