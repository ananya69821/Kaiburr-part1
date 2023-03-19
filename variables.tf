
locals {
  common_tags = {
    Environment = var.env
    Billing = "Sunwing"
    Program = "SunwingPOC"
  }
}

variable "env" {
  type    = string
   #default = "dev"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "sku_tier" {
  type = map(any)
  default = {
    "cn02d" = "Basic"
    "cn02q" = "Basic"
  }
}

variable "sku_size" {
  type = map(any)
  default = {
    "cn02d" = "B1"
    "cn02q" = "B1"
  }
}

variable "sku_capacity" {
  type = map(any)
  default = {
    "cn02d" = 1
    "cn02q" = 1
  }
}

variable "env_name" {
  type = map(any)
  default = {
    "cn02d" = "dev"
    "cn02q" = "qa"
  }
}

variable "kv_url" {
  type = map(any)
  default = {
    "cn02d" = "https://ch02d-kvdev001.vault.azure.net"
    "cn02q" = "https://ch02q-kvqa001.vault.azure.net"
    "cn02u" = "https://ch02u-kvuat001.vault.azure.net"
    "cn02p" = "https://ch02p-kvprd001.vault.azure.net"
  }
  
}

# variable "addrs" {
#   type = string
#   default = "10.212.160.0/20"
# }

variable "subnet_names" {
  type = map(any)
  description = "This defines the subnets within Virtual Network for appservice"
  default = {
    "addrs"= "10.1.1.0/24"
  }
   
}

variable "virtual_network_addrs" {
  type = map(any)
  description = "Address space values for Virtual Network"
  default = {
    "vnetaddr" = "10.1.0.0/16"
      }  
}
