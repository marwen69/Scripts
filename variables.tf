variable "vsphere_user" {
  description = "vSphere user name"
  type        = string
  default     = "" # Leave empty to pull from environment variable
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  default     = "" # Leave empty to pull from environment variable
}


variable "vsphere_vcenter" {
  description = "vSphere vCenter server address"
  type        = string
}

variable "vsphere-datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "vm-datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "vsphere-host" {
  description = "vSphere host (standalone)"
  type        = string
}

variable "vm-network" {
  description = "vSphere network"
  type        = string
}

variable "vm-template-name" {
  description = "vSphere template name"
  type        = string
}

variable "vsphere-template-folder" {
  description = "The folder in vSphere where the VM template is located"
  type        = string
  default     = "" # Leave empty if the template is not in a folder
}

variable "cpu" {
  description = "Number of CPUs"
  type        = number
}

variable "cores-per-socket" {
  description = "Number of cores per socket"
  type        = number
}

variable "ram" {
  description = "Amount of RAM in MB"
  type        = number
}

variable "disksize" {
  description = "Disk size in GB"
  type        = number
}

variable "vm-guest-id" {
  description = "Guest ID for the virtual machine"
  type        = string
}

variable "vsphere-unverified-ssl" {
  description = "Allow unverified SSL certificates"
  type        = string
}

variable "vm-domain" {
  description = "Domain for the virtual machine"
  type        = string
}

variable "name" {
  description = "Base name of the virtual machine"
  type        = string
}

variable "ipv4_addresses" {
  description = "List of IPv4 addresses for the virtual machines"
  type        = list(string)
  default     = ["172.29.31.99", "172.29.31.100"] # Static IP addresses
}

variable "ipv4_gateway" {
  description = "IPv4 gateway for the virtual machine"
  type        = string
}

variable "ipv4_netmask" {
  description = "IPv4 netmask"
  type        = string
}

variable "dns_server_list" {
  description = "List of DNS servers"
  type        = list(string)
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
}
