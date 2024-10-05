resource "oci_core_instance" "vm_1" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = "<SUBNET_OCID>"
  }

  source_details {
    source_type = "image"
    image_id    = data.oci_core_images.oracle_linux.image_id
  }

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  metadata = {
    ssh_authorized_keys = file("<SSH_PUBLIC_KEY_PATH>")
  }

  display_name = "free-tier-vm1"
}

resource "oci_core_instance" "vm_2" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = "<SUBNET_OCID>"
  }

  source_details {
    source_type = "image"
    image_id    = data.oci_core_images.oracle_linux.image_id
  }

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  metadata = {
    ssh_authorized_keys = file("<SSH_PUBLIC_KEY_PATH>")
  }

  display_name = "free-tier-vm2"
}