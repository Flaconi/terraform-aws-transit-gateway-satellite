data "aws_vpc" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name_to_attach]
  }
}

data "aws_subnets" "this" {
  provider = aws.satellite
  count    = local.create ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this[0].id]
  }

  dynamic "filter" {
    for_each = var.attachment_subnet_filters
    content {
      name   = filter.value["name"]
      values = filter.value["values"]
    }
  }
}

data "aws_subnets" "private" {
  provider = aws.satellite
  count    = local.create ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this[0].id]
  }

  dynamic "filter" {
    for_each = var.private_subnet_filters
    content {
      name   = filter.value["name"]
      values = filter.value["values"]
    }
  }
}

data "aws_route_tables" "all" {
  provider = aws.satellite
  count    = local.create ? 1 : 0
  vpc_id   = data.aws_vpc.this[0].id
}

data "aws_route_table" "all" {
  provider = aws.satellite
  for_each = toset(data.aws_route_tables.all[0].ids)
  vpc_id   = data.aws_vpc.this[0].id

  filter {
    name   = "route-table-id"
    values = [each.value]
  }
}

data "aws_route_table" "this" {
  provider = aws.satellite
  count    = local.create ? length(local.private_subnets_with_rt) : 0

  subnet_id = sort(local.private_subnets_with_rt)[count.index]
}

data "aws_ec2_transit_gateway" "this" {
  provider = aws.hub
  count    = local.create && var.transit_gateway_hub_name != "" ? 1 : 0

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
  count    = local.create && var.transit_gateway_hub_name != "" ? 1 : 0

  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.this[0].id]
  }
}

data "aws_ram_resource_share" "this" {
  provider = aws.hub
  count    = local.create && var.transit_gateway_hub_name != "" ? 1 : 0

  name           = var.transit_gateway_hub_name
  resource_owner = "SELF"
}
