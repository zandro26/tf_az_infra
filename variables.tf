variable "env" {
  type    = string
}

variable "conns" {
  type    = map
}

variable "az_client_secret" {
  type    = string
  sensitive = true  
}

