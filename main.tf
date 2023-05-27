resource "random_pet" "rg_name" {
  prefix = var.resouces_group_name_prefix
}

resource "random_pet" "azurerm_mssql_server_name" {
  prefix = var.mssql_server_name_prefix
}

resource "random_pet" "container_group_name" {
  prefix = var.container_group_name_prefix
}

resource "random_string" "storage_account_name" {
  length           = 16
  special          = false
  numeric = true
  upper = false
  lower = true
}

resource "random_string" "bcrypt_secret" {
	length = 16
	special = false
}

resource "random_string" "jwt_secret" {
	length = 16
	special = false
}

resource "random_password" "mssql_sa_password" {
  count       = var.mssql_sa_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  mssql_sa_password = try(random_password.mssql_sa_password[0].result, var.mssql_sa_password)
}

resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = random_pet.rg_name.id
}

resource "azurerm_mssql_server" "server" {
  name = random_pet.azurerm_mssql_server_name.id
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  administrator_login = var.sa_username
  administrator_login_password = local.mssql_sa_password
  version = "12.0"
  minimum_tls_version = "1.0"
}

resource "azurerm_mssql_database" "db" {
  name = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
}

resource "azurerm_storage_account" "storage_account" {
  name = random_string.storage_account_name.id
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_container_group" "container_group" {
  name = random_pet.container_group_name.id
	resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  ip_address_type = "Public"
  dns_name_label = var.container_group_dns_label
  os_type = "Linux"
	container {
		name = "plp-server"
		image = var.server_image
		cpu = var.server_cpu_cores
		memory = var.server_memory
		
		environment_variables = {
			"NODENV" = "prod"
			"PORT" = var.port
			"MSSQL_HOST" = azurerm_mssql_server.server.fully_qualified_domain_name
			"MSSQL_USERNAME" = azurerm_mssql_server.server.administrator_login
			"MSSQL_PASSWORD" = azurerm_mssql_server.server.administrator_login_password
			"BCRYPT_SECRET" = random_string.bcrypt_secret.id
			"JWT_SECRET" = random_string.jwt_secret.id
			"JWT_LIFETIME" = "30m"
			"REFRESH_TOKEN_LIFETIME" = "7"
			"AZURE_BLOB_CONSTRING" = azurerm_storage_account.storage_account.primary_connection_string
			"BLOB_CONTAINER_NAME" = "plpcontainer"
			"RABBITMQ" = "amqps://ilofetgw:gj1g8kn3VanTUwb1soO9M2uZpjWSZbxu@armadillo.rmq.cloudamqp.com/ilofetgw"
			"RABBITMQ_QUEUE_NAME" = "judge"
		}

		ports {
			port = 80
			protocol = "TCP"
		}
	}
}