output "resource_grouup_name" {
  value = azurerm_resource_group.local_azure_resource_roup.name
}


output "splat" {
  value = local.nsg_rules[*].allow_https
  
}