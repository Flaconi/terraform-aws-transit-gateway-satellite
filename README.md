# Terraform Transit Gateway "satellite" module

We are following the hub-spoke(s) (aka [star network][1]) network topology
model.

This Terraform module aims to handle the AWS resources required by a so-called
"satellite" node.

It is important to mention that the invocation of this module is going to
actually make cross-account changes. That is, we need to adjust the
configuration on the hub side (mainly routing).

This module assumes that its pair module was used:
[terraform-aws-transit-gateway-hub][2] to handle the actual TGW.

Check out the [examples][3] in the aforementioned module.

## Supported resources

At the moment, this module only supports attaching _VPCs_ to the TGW.
Support for VPN tunnels will be added soon.

## Assumptions

### Credentials

The module starts from the assumption that the `aws_login_profile` allows the
user to assume the necessary IAM roles, as required, to make the necessary
changes (and in the case of the `satellite` module, cross-account).

See [this example][4] to first make sure that the credentials you want to use
allow for cross-account actions.

You can read more about how Terraform handles this [here][5].

Obviously, all the [supported authentication][6] methods can also be used.

### Routing

For creating the network routes on the satellite side, the module expects to
find the keyword "_private_" in the name of the subnets, so that it may collect
their IDs and those of their associated routing tables.
Check the `subnet_name_keyword_selector` variable if you want to change this.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws.hub | n/a |
| aws.satellite | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_account\_id\_hub | AWS account number containing the TGW hub | `string` | n/a | yes |
| aws\_login\_profile | Name of the AWS login profile as seen under ~/.aws/config used for assuming cross-account roles | `any` | n/a | yes |
| role\_to\_assume\_hub | IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ROLE-HUB) | `string` | n/a | yes |
| attachment\_subnet\_filters | List of maps selecting the subnet(s) where TGW will be attached | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))<br></pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]<br></pre> | no |
| aws\_account\_id\_satellite | AWS account number containing the TGW satellite | `string` | `""` | no |
| hub\_destination\_cidr\_blocks | List of CIDRs to be routed for the hub | `list(string)` | `[]` | no |
| private\_subnet\_filters | List of maps selecting the subnet(s) which are private | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))<br></pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]<br></pre> | no |
| private\_subnets\_strict\_acl\_rules | Create additional ACLs for private subnets to restrict inbound traffic only to VPC itself and VPCs paired over TGW | `bool` | `false` | no |
| ram\_resource\_association\_id | Identifier of the Resource Access Manager Resource Association | `string` | `""` | no |
| role\_to\_assume\_satellite | IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ROLE-SATELLITE) | `string` | `""` | no |
| route\_entire\_satellite\_vpc | Boolean flag for toggling the creation of network routes for all the subnets of the satellite VPC | `bool` | `false` | no |
| route\_private\_subnets\_via\_tgw | Use TGW attachment as a default route (0.0.0.0/0) for private subnets. Value `satellite_destination_cidr_block`s will be ignored. | `bool` | `false` | no |
| satellite\_create | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| satellite\_destination\_cidr\_blocks | List of CIDRs to be routed for the satellite | `list(string)` | `[]` | no |
| transit\_gateway\_default\_route\_table\_association | Set this to false when the hub account also becomes a satellite. Check the official docs for more info. | `bool` | `true` | no |
| transit\_gateway\_default\_route\_table\_propagation | Set this to false when the hub account also becomes a satellite. Check the official docs for more info. | `bool` | `true` | no |
| transit\_gateway\_hub\_name | Name of the Transit Gateway to attach to | `string` | `""` | no |
| transit\_gateway\_id | Identifier of the Transit Gateway | `string` | `""` | no |
| transit\_gateway\_route\_table\_id | Identifier of the Transit Gateway Route Table | `string` | `""` | no |
| vpc\_name\_to\_attach | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| transit\_gateway\_vpc\_attachment\_id | Identifier of the Transit Gateway VPC Attachment |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## To do

- Collect TGW ID directly rather than using a RAM data source
  ([currently not supported][7])
- Add support for VPN attachments

[1]: https://en.wikipedia.org/wiki/Star_network
[2]: https://github.com/Flaconi/terraform-aws-transit-gateway-hub
[3]: https://github.com/Flaconi/terraform-aws-transit-gateway-hub/tree/master/examples
[4]: https://docs.aws.amazon.com/cli/latest/reference/sts/assume-role.html#examples
[5]: https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly
[6]: https://www.terraform.io/docs/providers/aws/index.html#authentication
[7]: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-transit-gateways.html#options
