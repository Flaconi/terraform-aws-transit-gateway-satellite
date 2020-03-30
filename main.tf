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
  #  depends_on = [var.ram_resource_association_id, data.aws_ram_resource_share.this.id]
  depends_on = [var.ram_resource_association_id]
}

resource "aws_ec2_transit_gateway_route" "this" {
  provider                       = aws.hub
  count                          = local.create ? 1 : 0
  destination_cidr_block         = var.destination_cidr_block
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
  provider = aws.satellite
  count    = local.create ? length(data.aws_route_table.this[*].subnet_id) : 0

  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = local.transit_gateway_id
  route_table_id         = sort(data.aws_route_table.this[*].route_table_id)[count.index]

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
