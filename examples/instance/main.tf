locals {
  region            = "jp-west-1"
  availability_zone = "west-11"
}

#####
# Provider
#
provider "nifcloud" {
  region = local.region
}

#####
# Security Group
#
resource "nifcloud_security_group" "this" {
  group_name        = "securitygroup"
  availability_zone = local.availability_zone
}

#####
# Module
#
module "instance" {
  source = "../../"

  instance_name       = "instance"
  availability_zone   = local.availability_zone
  security_group_name = nifcloud_security_group.this.group_name

  key_name = "webkey"

  # volume
  volume_size = 100
}
