locals {
  create = var.satellite_create

  transit_gateway_id = var.transit_gateway_id == "" ? data.aws_ec2_transit_gateway.this[0].id : var.transit_gateway_id

  transit_gateway_route_table_id = var.transit_gateway_route_table_id == "" ? data.aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id

  routing_tables_all     = data.aws_route_tables.all[0].ids
  routing_tables_private = data.aws_route_table.this[*].route_table_id
  routing_tables_rest    = setsubtract(local.routing_tables_all, local.routing_tables_private)

  routes_in_tables_private = [
    for pair in setproduct(local.routing_tables_private, var.route_private_subnets_via_tgw ? ["0.0.0.0/0"] : var.satellite_destination_cidr_blocks) : {
      table_id        = pair[0]
      dest_cidr_block = pair[1]
    }
  ]

  routes_in_tables_rest = [
    for pair in setproduct(local.routing_tables_rest, var.satellite_destination_cidr_blocks) : {
      table_id        = pair[0]
      dest_cidr_block = pair[1]
    }
  ]

  routes_in_tables_all = concat(local.routes_in_tables_private, local.routes_in_tables_rest)

  routes_in_tables = var.route_entire_satellite_vpc ? local.routes_in_tables_all : local.routes_in_tables_private

}
