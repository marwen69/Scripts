# vSphere Specific


vsphere_vcenter        = "172.29.31.94"
vsphere-datacenter     = "Datacenter"
vsphere-host           = "172.29.31.95"
vm-datastore           = "datastore1"
vm-network             = "VM Network"
vm-template-name       = "centos9"
vsphere-template-folder = "" # Leave empty if the template is not in a folder

# VM Configuration
name                   = "centos7_64Guest"
cpu                    = 4
cores-per-socket       = 1
ram                    = 4096
disksize               = 100 # in GB
vm-guest-id            = "centos7_64Guest"
vsphere-unverified-ssl = "true"
vm-domain              = "home"

# Network Configuration
ipv4_addresses         = ["172.29.31.99", "172.29.31.100"] # Static IP addresses
ipv4_gateway           = "172.29.31.254"
ipv4_netmask           = "24"
dns_server_list        = ["172.29.31.94", "8.8.8.8"]

# SSH Configuration
public_key             = ""
ssh_username           = ""
