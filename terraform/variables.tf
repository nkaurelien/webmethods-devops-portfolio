variable "instance_slug" {
  description = "Command Central Server Instance Slug"
  type        = string
  default     = "webmethods-cc-server"
}

variable "key-name" {
  default = "dev/nkaurelien"
}

variable "ssh_public_key" {
  description = "Command Central Server Instance Public Key path"
  type        = string
  default     = "ssh-key/nkaurelien.pub"
}

variable "ssh_user" {
  description = "Command Central Server Instance User during installation"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "Command Central Server Instance Private Key path"
  type        = string
  default     = "ssh-key/nkaurelien.key"
}

