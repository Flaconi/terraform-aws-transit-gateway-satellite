provider "aws" {
  alias  = "satellite"
  region = "eu-central-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_account_id_satellite}:role/${var.role_to_assume_satellite}"
    session_name = "tf-tgw-module-satellite"
  }
}

provider "aws" {
  alias  = "hub"
  region = "eu-central-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id_hub}:role/${var.role_to_assume_hub}"
    session_name = "tf-tgw-module-satellite"
  }
}
