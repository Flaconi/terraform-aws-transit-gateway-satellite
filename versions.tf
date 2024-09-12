terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
      configuration_aliases = [
        aws.hub,
        aws.satellite
      ]
    }
  }
  required_version = ">= 1.0"
}
