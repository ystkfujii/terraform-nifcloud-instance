# terraform-nifcloud-instance

Terraform module for provisioning instance.

Included resource
- nifcloud_key_pair
- nifcloud_instance
- nifcloud_volume

## Usage

There are examples included in the examples folder but simple usage is as follows:

```hcl
provider "nifcloud" {
  region     = "jp-west-1"
}

# security group
resource "nifcloud_security_group" "this" {
  group_name        = "securitygroup"
  availability_zone = "west-11"
}

# module
module "instance" {
  source  = "ystkfujii/instance/nifcloud"

  instance_name     = "instance"
  availability_zone = "west-11"

  key_name = "deployer"
  security_group_name = nifcloud_security_group.this.group_name
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Inputs


| Name                | Description                                                                                                  | Type   | Default                 |
| ------------------- | ------------------------------------------------------------------------------------------------------------ | ------ | ----------------------- |
| availability_zone   | The availability zone                                                                                        | string |                         |
| instance_name       | Used as instance_id and volume_id                                                                            | string |                         |
| security_group_name | The security group name to associate with instance                                                           | string |                         |
| key_name            | The key name of the Key Pair to use for the instance                                                         | string |                         |
| public_ip_address   | The elastic IP to associate to the instance                                                                  | string | null                    |
| interface_private   | The IP address and network ID for the private interface                                                      | object | null                    |
| ssh_port            | SSH port                                                                                                     | number | 22                      |
| volume_size         | The disk size(unit:GB)                                                                                       | number | 100                     |
| volume_disk_type    | The volume description                                                                                       | string | High-Speed Storage A    |
| volume_reboot       | When you want to increase the size of an existing volume, the argument that specifies server restart options | string | true                    |
| instance_type       | The type of instance to start. Updates to this field will trigger a stop/start of the instance               | string | e-large                 |
| image_name          | The name of image                                                                                            | string | Ubuntu Server 22.04 LTS |
| accounting_type     | Accounting type                                                                                              | string | 1                       |

## Outputs

| Name        | Description                        |
| ----------- | ---------------------------------- |
| instance_id | The instance name                  |
| unique_id   | The unique ID of instance          |
| private_ip  | The private ip address of instance |
| public_ip   | The public ip address of instance  |
| private_key | The generated private key          |


## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Nifcloud Account you execute the module with has the right permissions.
    - You can set environment variable `NIFCLOUD_ACCESS_KEY_ID` and `NIFCLOUD_SECRET_ACCESS_KEY`

### Software Dependencies

- [Terraform](https://www.terraform.io/downloads.html) 1.3.7
- [Terraform Provider for Nifcloud](https://registry.terraform.io/providers/nifcloud/nifcloud/latest) 1.7.0

## Author

- Yoshitaka Fujii ([@ystkfujii](https://github.com/ystkfujii))