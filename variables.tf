variable "resource_group_location" {
  default = "southeastasia"
  description = "Location of resources group"
}

variable "resouces_group_name_prefix" {
  default = "plp"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "mssql_server_name_prefix" {
	default = "sql"
	description = "SQL Server prefix"
}

variable "sql_db_name" {
	default = "plp"
	description = "Db name"
}

variable "sa_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azadmin"
}

variable "mssql_sa_password" {
	type = string
	description = "SQL SA PASSWORD"
	sensitive = true
	default = null
}

variable "container_group_name_prefix" {
	type = string
	description = "Container group name prefix"
	default = "aci"
}

variable "container_group_dns_label" {
	type = string
	description = "DNS name label"
	default = "plp-aci"
}

variable "server_instance_prefix" {
	type = string
	description = "Server container instance prefix"
	default = "server"
}

variable "server_image" {
	type = string
	description = "server image"
	default = "phungthanhtu/plp_server:amd64"
}

variable "engine_image" {
	type = string
	description = "engine image"
	default = "phungthanhtu/plp_engine:amd64"
}

variable "port" {
	type = number
	description = "default server port"
	default = 8080
}

variable "server_cpu_cores" {
	type = number
	description = "cpu cores for the server"
	default = 2
}

variable "server_memory" {
	type = number
	description = "server memory"
	default = 2
}

variable "engine_cpu_cores" {
	type = number
	description = "cpu cores for the engine"
	default = 2
}

variable "engine_memory" {
	type = number
	description = "engine memory"
	default = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}
