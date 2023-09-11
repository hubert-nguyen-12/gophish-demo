terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    mailgun = {
      source = "wgebis/mailgun"
      version = "0.7.4"
    }
    twingate = {
      source = "twingate/twingate"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}