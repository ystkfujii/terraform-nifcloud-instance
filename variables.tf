variable "availability_zone" {
  description = "The availability zone"
  type        = string
}

variable "instance_name" {
  description = "Used as instance_id and volume_id"
  type        = string
}

variable "security_group_name" {
  description = "The security group name to associate with instance"
  type        = string
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance. By default, sshkey is generated"
  type        = string
}

variable "public_ip_address" {
  description = "The elastic IP to associate to the instance"
  type        = string
  default     = null
}

variable "interface_private" {
  description = "The IP address and network ID for the private interface"
  type = object({
    ip_address = string
    network_id = string
  })
  default = null
  validation {
    condition     = var.interface_private == null ? true : can(cidrnetmask(var.interface_private.ip_address))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
  validation {
    condition = alltrue([
      var.ssh_port >= 1,
      var.ssh_port <= 65535,
    ])
    error_message = "Must be between 1 and 65535."
  }
}

variable "extra_userdata" {
  type    = string
  default = ""
}

variable "volume_size" {
  description = "The disk size(unit:GB)"
  type        = number
  default     = 0
}

variable "volume_disk_type" {
  description = "The volume description"
  type        = string
  default     = "High-Speed Storage A"
}

variable "volume_reboot" {
  description = "When you want to increase the size of an existing volume, the argument that specifies server restart options"
  type        = string
  default     = "true"
  validation {
    condition = anytrue([
      var.volume_reboot == "force", // Force restart the instance
      var.volume_reboot == "true",  // Restart the instance
      var.volume_reboot == "false", // Do not restart the instance
    ])
    error_message = "Must be a force, true or false."
  }
}

variable "instance_type" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the instance"
  type        = string
  default     = "e-large"
}

variable "image_name" {
  description = "The name of image"
  type        = string
  default     = "Ubuntu Server 22.04 LTS"
}

variable "accounting_type" {
  description = "Accounting type"
  type        = string
  default     = "1"
  validation {
    condition = anytrue([
      var.accounting_type == "1", // Monthly
      var.accounting_type == "2", // Pay per use
    ])
    error_message = "Must be a 1 or 2."
  }
}