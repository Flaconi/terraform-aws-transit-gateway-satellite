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

For example, this can be the so-called `login` profile, as documented
[here][4], which allows us to assume the corresponding IAM role(s) in various
AWS accounts.

You can read more about how Terraform handles this [here][5].

### Routing

For creating the network routes on the satellite side, the module expects to
find the keyword "_private_" in the name of the subnets, so that it may collect
their IDs and those of their associated routing tables. 

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
| role\_to\_assume\_hub | IAM role name to assume in the AWS account containing the TGW hub (eg. ASSUME-ENG-OPS) | `string` | n/a | yes |
| aws\_account\_id\_satellite | AWS account number containing the TGW satellite | `string` | `""` | no |
| destination\_cidr\_block | CIDR to be routed | `string` | `""` | no |
| role\_to\_assume\_satellite | IAM role name to assume in the AWS account containing the TGW satellite (eg. ASSUME-ENG-OPS) | `string` | `""` | no |
| satellite\_create | Boolean flag for toggling the handling of satellite resources | `bool` | `false` | no |
| transit\_gateway\_id | Identifier of the Transit Gateway | `string` | `""` | no |
| transit\_gateway\_route\_table\_id | Identifier of the Transit Gateway Route Table | `string` | `""` | no |
| vpc\_name\_to\_attach | Name of the satellite VPC to be attached to the TGW | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| transit\_gateway\_vpc\_attachment\_id | Identifier of the Transit Gateway VPC Attachment |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

[1]: https://en.wikipedia.org/wiki/Star_network
[2]: https://github.com/Flaconi/terraform-aws-transit-gateway-hub
[3]: https://github.com/Flaconi/terraform-aws-transit-gateway-hub/tree/WIP/examples
[4]: https://github.com/Flaconi/devops-docs/blob/master/doc/howto/aws-azure-login.md
[5]: https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly
