# setup vCenter connection for providers
provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

# identify vCenter variables which will feed into the 'resource' block
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "vsphere_compute_cluster" {
  name = "${var.vsphere_compute_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  for_each = var.kubes_control_plane
  name = each.value.datastore
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name = "${var.vsphere_datastore_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_virtual_machine_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# this is where the VMs really get provisioned
# the for_each loop will iterate over all of the input VMs in var.kubes_control_plane
# VM-specific values such as hostname and IP address are accessed through 'each.value.<property_name>'
resource "vsphere_virtual_machine" "vm" {
  for_each = var.kubes_control_plane

  name = each.value.vm_name
  resource_pool_id = "${data.vsphere_compute_cluster.vsphere_compute_cluster.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore[each.key].id}"
  folder = "${var.vsphere_folder_name}"

  num_cpus = "${data.vsphere_virtual_machine.template.num_cpus}"
  memory   = "${data.vsphere_virtual_machine.template.memory}"
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label = "disk0"
    size  = 100
  }

  # these customization options get passed in to the VMware VM customization process
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = each.value.vm_name
        domain = "homelab"
      }
      network_interface {
        ipv4_address = each.value.vm_ip
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.0.1.1"
      dns_server_list = ["10.0.1.10", "10.0.1.11"]
    }
  }

  connection {
    type     = "ssh"
    user     = "packer"
    password = var.vm_password
    host     = each.value.vm_ip
  }

  # post-deployment commands - run the script /home/packer/first_time_setup.sh
  # which is expected to exist on the template
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/packer/first_time_setup.sh",
      "echo '${var.vm_password}\n' | sudo -S -k /home/packer/first_time_setup.sh",
      "rm ~/first_time_setup.sh"
    ]
  }
}
