satellite_create = true

vpc_name_to_attach = "ci-tgw"

satellite_destination_cidr_blocks = ["208.67.222.222/32", "208.67.220.220/32"]
hub_destination_cidr_blocks       = ["8.8.4.4/32", "8.8.8.8/32"]

attachment_subnet_filters = [
  {
    name   = "tag:Name"
    values = ["*public*"]
  },
  {
    name   = "availability-zone"
    values = ["eu-central-1c"]
  }
]

transit_gateway_hub_name = "test-tgw-satellite-default-route"

route_private_subnets_via_tgw = true

private_subnet_filters = [
  {
    name   = "tag:Name"
    values = ["*private*"]
  },
  {
    name   = "availability-zone"
    values = ["eu-central-1a", "eu-central-1b"]
  }
]
