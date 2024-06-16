# output "asi_consent_url" {
#   value = {
#     for c, i in module.snowflake.azure_storage_integration:
#       c => i.azure_consent_url 
#   }
# }