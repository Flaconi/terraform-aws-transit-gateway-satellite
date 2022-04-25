resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  provider           = aws.satellite
  count              = local.create ? 1 : 0
  subnet_ids         = data.aws_subnets.this[0].ids
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = data.aws_vpc.this[0].id

  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

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
  route_table_id         = each.value[0].table_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_network_acl" "private" {
  provider   = aws.satellite
  count      = local.create && var.private_subnets_strict_acl_rules ? 1 : 0
  vpc_id     = data.aws_vpc.this[0].id
  subnet_ids = data.aws_subnets.private[0].ids
}

resource "aws_network_acl_rule" "private_default_egress" {
  provider = aws.satellite
  count    = local.create && var.private_subnets_strict_acl_rules ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_default_ingress" {
  provider = aws.satellite
  count    = local.create && var.private_subnets_strict_acl_rules ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = data.aws_vpc.this[0].cidr_block
}

resource "aws_network_acl_rule" "private_ingress" {
  provider = aws.satellite
  for_each = local.create && var.private_subnets_strict_acl_rules ? toset(var.satellite_destination_cidr_blocks) : []

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 101 + index(var.satellite_destination_cidr_blocks, each.key)
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = each.key
}
