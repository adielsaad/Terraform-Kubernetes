variable "region" {
  type        = string
  default     = "West Europe"
  description = "Region location"
}

variable "rg_name" {
  type        = string
  default     = "myRg"
  description = "description"
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "Virtual Machine Size"
}

variable "user_name" {
  type        = string
  default     = "adiel"
  description = "User Name"
}

variable "key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Key path for the virtual machine"
}

variable "private_key" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Private Key for the VM"
}


variable "vms_quantity" {
  type        = string
  default     = "2"
  description = "Quantity of virtual machines"
}
