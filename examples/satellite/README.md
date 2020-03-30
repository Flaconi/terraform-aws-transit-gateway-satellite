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
| destination\_cidr\_block | CIDR to be routed | `string` | `""` | no |
| satellite\_create | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| subnet\_name\_keyword\_selector | Keyword matching the name of the subnet(s) for which the routing will be added (i.e. private) | `string` | `"private"` | no |
| transit\_gateway\_hub\_name | Name of the Transit Gateway to attach to | `string` | `""` | no |
| vpc\_name\_to\_attach | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
