###cloud vars
variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description  = "Second subnet for zone b"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develope_b"
  description  = "second subnet name"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description  = "VM os family"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description  = "compute instance name"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description  = "compute instance name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description  = "yandex platform type"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description  = "VM core number"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description  = "VM memory amount GB"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description  = "VM core fraction"
}

variable "vm_db_serial-port-enable" {
  type        = number
  default     = 1
  description  = "VM serial port"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description  = "VM preemtible or not"
}

variable "vm_db_nat" {
  type        = bool
  default     = false
  description  = "VM nat"
}
