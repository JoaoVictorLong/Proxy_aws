terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


variable "regions" {
  default = [
    "us-east-1",      # US East (N. Virginia)
    "us-east-2",      # US East (Ohio)
    "us-west-1",      # US West (N. California)
    "us-west-2",      # US West (Oregon)
    "ap-south-1",     # Asia Pacific (Mumbai)
    "ap-southeast-1", # Asia Pacific (Singapore)
    "ap-southeast-2", # Asia Pacific (Sydney)
    "ap-northeast-3", # Asia Pacific (Jakarta)
    "ap-northeast-1", # Asia Pacific (Tokyo)
    "ap-northeast-2", # Asia Pacific (Seoul)
    "ca-central-1",   # Canada (Central)
    "eu-central-1",   # Europe (Frankfurt)
    "eu-west-1",      # Europe (Ireland)
    "eu-west-2",      # Europe (London)
    "eu-west-3",      # Europe (Paris)
    "eu-north-1",     # Europe (Stockholm)
    "sa-east-1"       # South America (São Paulo)
  ]
}

resource "random_shuffle" "aws_region" {
  input        = var.regions
  result_count = 1
}