# Standalone invocation of the Transit Gateway satellite module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_account\_id\_hub | AWS account number containing the TGW hub | `string` | n/a | yes |
| aws\_account\_id\_satellite | List of AWS account numbers representing the satellites of the TGW | `list` | n/a | yes |
| aws\_login\_profile | Name of the AWS login profile as seen under ~/.aws/config used for assuming cross-account roles | `any` | n/a | yes |
| role\_to\_assume\_hub | IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ROLE-HUB) | `string` | n/a | yes |
| role\_to\_assume\_satellite | IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ROLE-SATELLITE) | `string` | n/a | yes |
| attachment\_subnet\_filters | List of maps selecting the subnet(s) where TGW will be attached | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))<br></pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "private"<br>    ]<br>  }<br>]<br></pre> | no |
| hub\_destination\_cidr\_blocks | List of CIDRs to be routed for the hub | `list` | `[]` | no |
| route\_entire\_satellite\_vpc | Boolean flag for toggling the creation of network routes for all the subnets of the satellite VPC | `bool` | `false` | no |
| satellite\_create | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| satellite\_destination\_cidr\_blocks | List of CIDRs to be routed for the satellite | `list` | `[]` | no |
| transit\_gateway\_hub\_name | Name of the Transit Gateway to attach to | `string` | `""` | no |
| transit\_gateway\_id | Identifier of the Transit Gateway | `string` | `""` | no |
| vpc\_name\_to\_attach | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
