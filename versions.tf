terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4"
      configuration_aliases = [
        aws.hub,
        aws.satellite
      ]
    }
  }
  required_version = ">= 0.15"
}
