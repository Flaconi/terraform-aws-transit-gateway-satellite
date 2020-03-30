locals {
  create = var.satellite_create

  transit_gateway_id = var.transit_gateway_id == "" ? data.aws_ec2_transit_gateway.this[0].id : var.transit_gateway_id

  transit_gateway_route_table_id = var.transit_gateway_route_table_id == "" ? data.aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
}
