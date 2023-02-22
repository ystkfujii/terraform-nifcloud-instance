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
  volume_create = true
  volume_size   = 100
}

# Comment out if you want to store locally
//resource "null_resource" "store_private_key" {
//  triggers = {
//    private_key = module.sshkey_uploader.private_key
//  }
//
//  provisioner "local-exec" {
//    command = "echo '${module.sshkey_uploader.private_key}' > ${path.root}/key ; chmod 0600 ${path.root}/key"
//  }
//}