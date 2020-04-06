satellite_create = true

aws_login_profile = "login"

role_to_assume_hub       = "ASSUME-ENG-CI"
role_to_assume_satellite = "ASSUME-ENG-CI"

vpc_name_to_attach = "default"

satellite_destination_cidr_blocks = ["208.67.222.222/32", "208.67.220.220/32"]
hub_destination_cidr_blocks       = ["8.8.4.4/32", "8.8.8.8/32"]

subnet_name_keyword_selector = "private"
transit_gateway_hub_name     = "test-tgw-fixture"
