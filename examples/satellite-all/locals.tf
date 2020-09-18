# Workaround for this error when passing undeclared vars using CI/CD
# https://github.com/hashicorp/terraform/issues/22004
# TODO: refactor it after issue is resolved
locals {
  aws_account_id_satellite = var.aws_account_id_satellite[0]
}
