variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Locations"
  default     = ["West us", "central india", "west india"]

}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    "environment" = "staging"
    "depaerment"  = "MSP"
    "Managed_by"  = "Ankit mahato"
  }
}

variable "network_config" {
  type        = tuple([string, string, number])
  description = "NetworkConfiguration (Vnet Address, subnet address,subnet musk)"
  default     = ["10.0.0.0/16", "10.0.2.0", 24]
}

# it only contains uniques values
variable "allowed_vm_sizes" {
  type = set(string)
  description = "this is used for allowed Vm sizes "
  default = [ "" ]
}


variable "storage_account_name" {
  type = set(string)
  description = "This is a storage account"
  default = [ "storageaccount11","storageaccount12" ]

  }

