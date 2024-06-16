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
variable "sf_private_key" {
  type    = string
  sensitive = true
}

variable "sf_private_key_passphrase" {
  type    = string
  sensitive = true
}

variable "dbt_token" {
  type    = string
  sensitive = true
}

variable "github_pem_file" {
  type    = string
  sensitive = true
}

variable "az_client_secret" {
  type    = string
  sensitive = true
}



# variable "az_client_id" {
#   type    = string
# }


# variable "az_tenant_id" {
#   type    = string
# }

# variable "az_subscription_id" {
#   type    = string
# }