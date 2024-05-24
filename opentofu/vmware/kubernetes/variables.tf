variable "vsphere_server" {
    default = "vcsa.homelab"
}

variable "vsphere_user" {
    default = "administrator@vsphere.local"
}

variable "vsphere_datacenter" {
    default = "Homelab"
}

variable "vsphere_compute_cluster" {
    default = "Cluster"
}

variable "vsphere_datastore_cluster" {
    default = "redsun"
}

variable "vsphere_resource_pool" {
    default = "Cluster"
}

variable "vsphere_network" {
    default = "VM Network"
}

variable "vsphere_virtual_machine_template" {
    default = "ubuntu-kubes-v1.2"
}

variable "vsphere_folder_name" {
    default = "Kubernetes"
}

variable "vsphere_password" {}
variable "vm_password" {}
variable "kubes_control_plane" {}
