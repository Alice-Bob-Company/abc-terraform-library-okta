# general
#---------------
variable "account_name" {
  type = string
}

variable "default_region" {
  type    = string
  default = "eu-central-1"
}

variable "module" {
  type        = string
  description = "The source of this terraform repository in relation to the executing repository"
}

variable "resource_owner" {
  type        = string
  description = "The main contact for this project. Should be an email to enable automated messages"
}

variable "okta_enalbed" {
  type        = bool
  description = "Okta module enabled?"
  default     = true
}
