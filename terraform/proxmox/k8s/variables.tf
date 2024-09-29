variable "vm_names" {
  type = list(string)
  default = ["master01","worker01","worker02"]
}

variable "vm_networks" {
  type = list(string)
  default = ["192.168.0.81/24","192.168.0.82/24","192.168.0.83/24"]
}

variable "iso_storage_pool" {
  type = string
  default = "local-lvm"
}

variable "target_node" {
  type = string
  default = "pve"
}

variable "net_gateway" {
  type = string
  default = "192.168.0.1"
}

variable "net_dns" {
  type = string
  default = "192.168.0.1"
}