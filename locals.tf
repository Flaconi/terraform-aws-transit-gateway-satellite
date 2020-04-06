locals {
  create = var.satellite_create

  transit_gateway_id = var.transit_gateway_id == "" ? data.aws_ec2_transit_gateway.this[0].id : var.transit_gateway_id

  transit_gateway_route_table_id = var.transit_gateway_route_table_id == "" ? data.aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id

  routes_in_tables = [
    for pair in setproduct(data.aws_route_table.this[*].route_table_id, var.satellite_destination_cidr_blocks) : {
      table_id        = pair[0]
      dest_cidr_block = pair[1]
    }
  ]
}
