# Standalone invocation of the Transit Gateway satellite module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw-satellite"></a> [tgw-satellite](#module\_tgw-satellite) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id_hub"></a> [aws\_account\_id\_hub](#input\_aws\_account\_id\_hub) | AWS account number containing the TGW hub | `string` | n/a | yes |
| <a name="input_aws_account_id_satellite"></a> [aws\_account\_id\_satellite](#input\_aws\_account\_id\_satellite) | AWS account ID representing the satellites of the TGW | `string` | n/a | yes |
| <a name="input_role_to_assume_hub"></a> [role\_to\_assume\_hub](#input\_role\_to\_assume\_hub) | IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ROLE-HUB) | `string` | n/a | yes |
| <a name="input_role_to_assume_satellite"></a> [role\_to\_assume\_satellite](#input\_role\_to\_assume\_satellite) | IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ROLE-SATELLITE) | `string` | n/a | yes |
| <a name="input_attachment_subnet_filters"></a> [attachment\_subnet\_filters](#input\_attachment\_subnet\_filters) | List of maps selecting the subnet(s) where TGW will be attached | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_hub_destination_cidr_blocks"></a> [hub\_destination\_cidr\_blocks](#input\_hub\_destination\_cidr\_blocks) | List of CIDRs to be routed for the hub | `list(string)` | `[]` | no |
| <a name="input_private_subnet_filters"></a> [private\_subnet\_filters](#input\_private\_subnet\_filters) | List of maps selecting the subnet(s) which are private | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_private_subnets_strict_acl_rules"></a> [private\_subnets\_strict\_acl\_rules](#input\_private\_subnets\_strict\_acl\_rules) | Create additional ACLs for private subnets to restrict inbound traffic only to VPC itself and VPCs paired over TGW | `bool` | `false` | no |
| <a name="input_route_entire_satellite_vpc"></a> [route\_entire\_satellite\_vpc](#input\_route\_entire\_satellite\_vpc) | Boolean flag for toggling the creation of network routes for all the subnets of the satellite VPC | `bool` | `false` | no |
| <a name="input_route_private_subnets_via_tgw"></a> [route\_private\_subnets\_via\_tgw](#input\_route\_private\_subnets\_via\_tgw) | Use TGW attachment as a default route (0.0.0.0/0) for private subnets. Value `satellite_destination_cidr_block`s will be ignored. | `bool` | `false` | no |
| <a name="input_satellite_create"></a> [satellite\_create](#input\_satellite\_create) | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| <a name="input_satellite_destination_cidr_blocks"></a> [satellite\_destination\_cidr\_blocks](#input\_satellite\_destination\_cidr\_blocks) | List of CIDRs to be routed for the satellite | `list(string)` | `[]` | no |
| <a name="input_transit_gateway_hub_name"></a> [transit\_gateway\_hub\_name](#input\_transit\_gateway\_hub\_name) | Name of the Transit Gateway to attach to | `string` | `""` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Identifier of the Transit Gateway | `string` | `""` | no |
| <a name="input_vpc_name_to_attach"></a> [vpc\_name\_to\_attach](#input\_vpc\_name\_to\_attach) | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
