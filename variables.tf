variable "env" {
  type    = string
}

variable "context" {
  type    = string
}

variable "conns" {
  type    = map
}

variable "application" {
  type    = string
}

variable "zone_loc" {
  type    = string
}

variable "platform" {
  type    = string
}

variable "az_client_secret" {
  type    = string
  sensitive = true
}


