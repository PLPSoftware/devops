output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "sql_server_name" {
  value = azurerm_mssql_server.server.name
}

output "sql_server_endpoint" {
  value = azurerm_mssql_server.server.fully_qualified_domain_name
}

output "sa_password" {
  sensitive = true
  value = local.mssql_sa_password
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_connection_string" {
  sensitive = true
  value = azurerm_storage_account.storage_account.primary_connection_string
}

output "mssql_connection_string" {
  sensitive = true
  value = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.server.administrator_login};Password=${azurerm_mssql_server.server.administrator_login_password};Encrypt=True;TrustServerCertificate=False;"
}

output "container_group_endpoint" {
  value = azurerm_container_group.container_group.ip_address
}

output "container_group_public_fqdn" {
  value = azurerm_container_group.container_group.fqdn
}