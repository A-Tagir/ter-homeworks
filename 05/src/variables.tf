###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

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

###common vars

variable "vm_username" {
  type        = string
  default     = "ubuntu"
  description = "example vm_web_username"
}

variable "vm_accounting_project" {
  type        = string
  default     = "accounting"
  description = "vm_web projectname"
}

variable "vm_owner" {
  type        = string
  default     = "a.tagir"
  description = "vm_web projectname"
}

###example vm_marketing var

variable "vm_marketing_project" {
  type        = string
  default     = "marketing"
  description = "vm_db projectname"
}



