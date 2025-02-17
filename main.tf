terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user != "" ? var.vsphere_user : env("VSPHERE_USER")
  password             = var.vsphere_password != "" ? var.vsphere_password : env("VSPHERE_PASSWORD")
  vsphere_server       = var.vsphere_vcenter
  allow_unverified_ssl = true
}


data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere-host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm-network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere-datacenter}/vm/${var.vsphere-template-folder != "" ? "${var.vsphere-template-folder}/" : ""}${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count = length(var.ipv4_addresses) # Create one VM for each IP address

  name             = count.index == 0 ? "master" : "worker" # Name the VMs as master and worker
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.cpu
  num_cores_per_socket = var.cores-per-socket
  memory           = var.ram
  guest_id         = var.vm-guest-id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
     label            = "${count.index == 0 ? "master" : "worker"}-disk"
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    size             = var.disksize == "" ? data.vsphere_virtual_machine.template.disks.0.size : var.disksize
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = count.index == 0 ? "master" : "worker"
        domain    = var.vm-domain
      }

      network_interface {
        ipv4_address = var.ipv4_addresses[count.index] # Use the IP from the list
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway = var.ipv4_gateway
      dns_server_list = var.dns_server_list
    }
  }

  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yaml", {
      name         = count.index == 0 ? "master" : "worker",
      ipv4_address = var.ipv4_addresses[count.index],
      ipv4_gateway = var.ipv4_gateway,
      dns_server_1 = var.dns_server_list[0],
      dns_server_2 = var.dns_server_list[1],
      public_key   = var.public_key,
      ssh_username = count.index == 0 ? "master" : "worker", # Set username dynamically
      vm-domain    = var.vm-domain
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml", {
      ssh_username = count.index == 0 ? "master" : "worker", # Set username dynamically
      public_key   = var.public_key,
      vm_name      = count.index == 0 ? "master" : "worker" # Pass the VM name
    }))
    "guestinfo.userdata.encoding" = "base64"
  }

  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
      clone[0].customize[0].dns_server_list,
      clone[0].customize[0].network_interface[0]
    ]
  }
}
