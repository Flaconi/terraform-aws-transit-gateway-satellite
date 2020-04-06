provider "aws" { alias = "satellite" }
provider "aws" { alias = "hub" }

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  provider           = aws.satellite
  count              = local.create ? 1 : 0
  subnet_ids         = data.aws_subnet_ids.this[0].ids
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = data.aws_vpc.this[0].id

  # When we create the TGW and the association through RAM in one run, we need
  # this to escape the race condition.
  depends_on = [var.ram_resource_association_id]
}

resource "aws_ec2_transit_gateway_route" "this" {
  provider                       = aws.hub
  count                          = local.create ? length(var.hub_destination_cidr_blocks) : 0
  destination_cidr_block         = element(var.hub_destination_cidr_blocks, count.index)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  provider                       = aws.hub
  count                          = local.create ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  provider                       = aws.hub
  count                          = local.create ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_route" "this" {
  for_each = {
    for route in local.routes_in_tables : "${route.table_id}.${route.dest_cidr_block}" => route...
  }

  provider = aws.satellite

  destination_cidr_block = each.value[0].dest_cidr_block
  transit_gateway_id     = local.transit_gateway_id
  route_table_id         = each.value[1].table_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
