variable env {
  type    = string
}

variable context {
  type    = string
}
variable platform {
  type    = string
}

variable application {
  type    = string
}

variable zone_loc {
  type    = string
}


variable az_resource_block {
  type    = map
  default = {}
}

variable az_storage_accounts {
  type    = map
  default = {}
}

variable az_locale {
  type    = string
}

variable "conns" {
  type    = map
}

variable "block_name" {
  type  =  map
   default = {}
}