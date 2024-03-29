locals {
  # userdata
  configure_ssh_port = templatefile("${path.module}/templates/configure_ssh_port.tftpl", {
    custom_ssh_port = var.ssh_port
  })
  configure_private_ip_address = var.interface_private == null ? "" : templatefile("${path.module}/templates/configure_private_ip_address.tftpl", {
    private_ip_address = var.interface_private.ip_address
  })
  configure_hostname = templatefile("${path.module}/templates/configure_hostname.tftpl", {
    hostname = var.instance_name
  })
  user_data = templatefile("${path.module}/templates/userdata.tftpl", {
    configure_private_ip_address = local.configure_private_ip_address
    configure_ssh_port           = local.configure_ssh_port
    configure_hostname           = local.configure_hostname
    extra_userdata               = var.extra_userdata
  })
}

data "nifcloud_image" "this" {
  image_name = var.image_name
}

resource "nifcloud_instance" "this" {

  instance_id       = var.instance_name
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.this.image_id
  key_name          = var.key_name
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

  user_data = local.user_data

  # The image_id changes when the OS image type is demoted from standard to public.
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "nifcloud_volume" "this" {
  count = var.volume_size == 0 ? 0 : 1

  size            = var.volume_size
  volume_id       = var.instance_name
  disk_type       = var.volume_disk_type
  instance_id     = nifcloud_instance.this.instance_id
  reboot          = var.volume_reboot
  accounting_type = var.accounting_type
}
