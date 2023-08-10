terraform {
  required_version = ">=1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.12.0"
    }
  }
}