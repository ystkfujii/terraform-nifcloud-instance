terraform {
  required_version = ">=1.3.7"
  required_providers {

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0, < 5.0.0"
    }

    nifcloud = {
      source  = "nifcloud/nifcloud"
      version = ">= 1.7.0, < 2.0.0"
    }
  }
}