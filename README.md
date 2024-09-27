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

The module starts from the assumption that your default aws profile allows the
user to assume the necessary IAM roles, as required, to make the necessary
changes (and in the case of the `satellite` module, cross-account).
You can use profile of your need if you set `AWS_PROFILE` or `AWS_DEFAULT_PROFILE`, e.g.:

```shell
export AWS_DEFAULT_PROFILE=login
```


See [this example][4] to first make sure that the credentials you want to use
allow for cross-account actions.

You can read more about how Terraform handles this [here][5].

Obviously, all the [supported authentication][6] methods can also be used.

### Routing

For creating the network routes on the satellite side, the module expects to
find the keyword "_private_" in the name of the subnets, so that it may collect
their IDs and those of their associated routing tables.
Check the `subnet_name_keyword_selector` variable if you want to change this.

When creating TGW attachments, AWS [supports adding only one subnet per AZ][8].
For example, when a VPC has 6 subnets, with each AZ having a pair consisting of
a public and a private subnet, it's recommended to only use the private subnets
when creating the TGW attachment.
For the described example, in the `eu-central-1` (Frankfurt) region, as
currently there are 3 Availability Zones, the TGW attachment will contain 3
(private) subnets.
The resources placed within the remaining subnets (public and/or private), will
also be able to route their traffic through the TGW.

### ACLs

__Caveat:__ Building on the [example](#routing) described above, when using
Network ACLs (NACLs), the behaviour is different between subnets that are part
of the TGW attachment and subnets that aren't.

Specifically, because the ACL rules are stateless (as opposed to the Security
Group rules, which are stateful), when trying to reach an external IP from a
subnet that is also part of the TGW attachment, this *will work even without*
an explicit ACL allow rule.

However, for another subnet that's not part of the TGW attachment, although
with a NACL allow rule for the targeted external CIDR in place, the traffic
will not flow.

This has to do with how NACL inbound rules are not being evaluated since the
resource (i.e. EC2 instance) is in the same subnet with the TGW association.

Unfortunately, AWS fails to provide explicit documentation for this behavior.
It is implied on [this][9] documentation page and they've been made aware of
this fact.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.69 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.hub"></a> [aws.hub](#provider\_aws.hub) | >= 5.69 |
| <a name="provider_aws.satellite"></a> [aws.satellite](#provider\_aws.satellite) | >= 5.69 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.private_default_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_default_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_route_table) | data source |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ram_resource_share) | data source |
| [aws_route_table.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id_hub"></a> [aws\_account\_id\_hub](#input\_aws\_account\_id\_hub) | AWS account number containing the TGW hub | `string` | n/a | yes |
| <a name="input_attachment_subnet_filters"></a> [attachment\_subnet\_filters](#input\_attachment\_subnet\_filters) | List of maps selecting the subnet(s) where TGW will be attached | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_aws_account_id_satellite"></a> [aws\_account\_id\_satellite](#input\_aws\_account\_id\_satellite) | AWS account number containing the TGW satellite | `string` | `""` | no |
| <a name="input_hub_destination_cidr_blocks"></a> [hub\_destination\_cidr\_blocks](#input\_hub\_destination\_cidr\_blocks) | List of CIDRs to be routed for the hub | `list(string)` | `[]` | no |
| <a name="input_private_subnet_filters"></a> [private\_subnet\_filters](#input\_private\_subnet\_filters) | List of maps selecting the subnet(s) which are private | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "tag:Name",<br>    "values": [<br>      "*private*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_private_subnets_strict_acl_rules"></a> [private\_subnets\_strict\_acl\_rules](#input\_private\_subnets\_strict\_acl\_rules) | Create additional ACLs for private subnets to restrict inbound traffic only to VPC itself and VPCs paired over TGW | `bool` | `false` | no |
| <a name="input_ram_resource_association_id"></a> [ram\_resource\_association\_id](#input\_ram\_resource\_association\_id) | Identifier of the Resource Access Manager Resource Association | `string` | `""` | no |
| <a name="input_route_entire_satellite_vpc"></a> [route\_entire\_satellite\_vpc](#input\_route\_entire\_satellite\_vpc) | Boolean flag for toggling the creation of network routes for all the subnets of the satellite VPC | `bool` | `false` | no |
| <a name="input_route_private_subnets_via_tgw"></a> [route\_private\_subnets\_via\_tgw](#input\_route\_private\_subnets\_via\_tgw) | Use TGW attachment as a default route (0.0.0.0/0) for private subnets. Value `satellite_destination_cidr_block`s will be ignored. | `bool` | `false` | no |
| <a name="input_satellite_create"></a> [satellite\_create](#input\_satellite\_create) | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| <a name="input_satellite_destination_cidr_blocks"></a> [satellite\_destination\_cidr\_blocks](#input\_satellite\_destination\_cidr\_blocks) | List of CIDRs to be routed for the satellite | `list(string)` | `[]` | no |
| <a name="input_security_group_referencing_support"></a> [security\_group\_referencing\_support](#input\_security\_group\_referencing\_support) | Whether Security Group Referencing Support is enabled. | `string` | `"disable"` | no |
| <a name="input_transit_gateway_default_route_table_association"></a> [transit\_gateway\_default\_route\_table\_association](#input\_transit\_gateway\_default\_route\_table\_association) | Set this to false when the hub account also becomes a satellite. Check the official docs for more info. | `bool` | `true` | no |
| <a name="input_transit_gateway_default_route_table_propagation"></a> [transit\_gateway\_default\_route\_table\_propagation](#input\_transit\_gateway\_default\_route\_table\_propagation) | Set this to false when the hub account also becomes a satellite. Check the official docs for more info. | `bool` | `true` | no |
| <a name="input_transit_gateway_hub_name"></a> [transit\_gateway\_hub\_name](#input\_transit\_gateway\_hub\_name) | Name of the Transit Gateway to attach to | `string` | `""` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Identifier of the Transit Gateway | `string` | `""` | no |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | Identifier of the Transit Gateway Route Table | `string` | `""` | no |
| <a name="input_vpc_name_to_attach"></a> [vpc\_name\_to\_attach](#input\_vpc\_name\_to\_attach) | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_vpc_attachment_id"></a> [transit\_gateway\_vpc\_attachment\_id](#output\_transit\_gateway\_vpc\_attachment\_id) | Identifier of the Transit Gateway VPC Attachment |

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
[8]: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html
[9]: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-nacls.html
