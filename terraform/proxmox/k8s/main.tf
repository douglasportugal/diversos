resource "proxmox_vm_qemu" "vm" {
    count = length(var.vm_names)
    name = var.vm_names[count.index]
    target_node = var.target_node
    ipconfig0 = "ip=${var.vm_networks[count.index]},gw=${var.net_gateway}"
    nameserver =  var.net_dns
    ciuser = "ubuntu"
    sshkeys = file("~/.ssh/id_rsa.pub")
    agent = 1
    clone = "ubuntu-2204-template"
    cores = 4
    sockets = 1
    cpu = "host"
    memory = 3072
    scsihw = "virtio-scsi-pci"

    # Setup the disk
    disks {
        ide {
            ide0 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    storage         = "local-lvm"
                    discard         = true
                }
            }
        }
    }
}
