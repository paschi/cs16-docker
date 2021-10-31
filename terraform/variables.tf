variable "location" {
  default = "Germany West Central"
}

variable "resource_group_name" {
  default = "rg-cs16"
}

variable "container_group_name" {
  default = "ci-cs16"
}

variable "container_name" {
  default = "cs16"
}

variable "container_image" {
  default = "ghcr.io/paschi/cs16-docker:main"
}

variable "container_cpu" {
  default = "2"
}

variable "container_memory" {
  default = "4"
}

variable "env_server_name" {
  default = "CS 1.6 Server"
}

variable "env_map" {
  default = "de_dust2"
}

variable "env_maxplayers" {
  default = "24"
}

variable "env_admin_steam" {
  default = ""
}

variable "env_sv_password" {
  default = ""
}

variable "env_rcon_password" {
  default = ""
}