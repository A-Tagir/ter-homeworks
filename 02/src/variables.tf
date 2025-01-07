###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "token" {
  type        = string
  default     = ""
  description = "IAM token"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description  = "VM os family"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-vm"
  description  = "compute instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description  = "yandex platform type"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description  = "VM core number"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description  = "VM memory amount GB"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description  = "VM core fraction"
}

variable "vm_web_serial-port-enable" {
  type        = number
  default     = 1
  description  = "VM serial port"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description  = "VM preemtible or not"
}

variable "vm_web_nat" {
  type        = bool
  default     = false
  description  = "VM nat"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}
