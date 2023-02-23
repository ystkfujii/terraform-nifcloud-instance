resource "tls_private_key" "this" {
  count      = var.key_name == null ? 1 : 0
  algorithm = "RSA"
}

locals {
  public_key  = var.key_name == null ? tls_private_key.this.public_key_openssh : var.key_name
  private_key = var.key_name == null ? tls_private_key.this.private_key_pem : ""
}

resource "nifcloud_key_pair" "this" {
  count      = var.key_name == null ? 1 : 0
  key_name   = var.instance_name
  public_key = base64encode(local.public_key)
}

data "nifcloud_image" "this" {
  image_name = var.image_name
}

resource "nifcloud_instance" "this" {

  instance_id       = var.instance_name
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.this.image_id
  key_name          = var.key_name == null ? nifcloud_key_pair.this[0].key_name : var.key_name
  security_group    = var.security_group_name
  instance_type     = var.instance_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.public_ip_address
  }

  network_interface {
    network_id = var.interface_private == null ? "net-COMMON_PRIVATE" : var.interface_private.network_id
    ip_address = var.interface_private == null ? null : "static"
  }

  user_data = var.interface_private == null ? null : templatefile("${path.module}/scripts/userdata.sh", {
    private_ip_address = var.interface_private.ip_address
    custom_ssh_port    = var.ssh_port
  })

  # The image_id changes when the OS image type is demoted from standard to public.
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "nifcloud_volume" "this" {
  count = var.volume_create ? 1 : 0

  size            = var.volume_size
  volume_id       = var.instance_name
  disk_type       = var.volume_disk_type
  instance_id     = nifcloud_instance.this.instance_id
  reboot          = var.volume_reboot
  accounting_type = var.accounting_type
}


