variable "name" {
  description = "The name of the database. Must be unique on the PostgreSQL server instance where it is configured."
  type        = string
}

variable "owner" {
  description = "The role name of the user who will own the database, or DEFAULT to use the default (namely, the user executing the command). To create a database owned by another role or to change the owner of an existing database, you must be a direct or indirect member of the specified role, or the username in the provider is a superuser. Defaults to null."
  type        = string
  default     = null
}

variable "connection_limit" {
  description = "How many concurrent connections can be established to this database. -1 means no limit. Defaults to -1."
  type        = number
  default     = -1
}

variable "allow_connections" {
  description = " If false then no one can connect to this database, if true, allowing connections (except as restricted by other mechanisms, such as GRANT or REVOKE CONNECT). Defaults to true."
  type        = bool
  default     = true
}

variable "is_template" {
  description = "If true, then this database can be cloned by any user with CREATEDB privileges; if false, then only superusers or the owner of the database can clone it. Defaults to false."
  type        = bool
  default     = false
}

variable "template" {
  description = "The name of the template database from which to create the database, or DEFAULT to use the default template. Changing this value will force the creation of a new resource as this value can only be changed when a database is created. Defaults to template0."
  type        = string
  default     = "template0"
}

variable "encoding" {
  description = "Character set encoding to use in the database. Specify a string constant (e.g. UTF8 or SQL_ASCII), or an integer encoding number. If unset or set to an empty string the default encoding is set to UTF8. If set to DEFAULT Terraform will use the same encoding as the template database. Changing this value will force the creation of a new resource as this value can only be changed when a database is created. Defaults to UTF8."
  type        = string
  default     = "UTF8"
}

variable "lc_collate" {
  description = "Collation order (LC_COLLATE) to use in the database. This affects the sort order applied to strings, e.g. in queries with ORDER BY, as well as the order used in indexes on text columns. If unset or set to an empty string the default collation is set to C. If set to DEFAULT Terraform will use the same collation order as the specified template database. Changing this value will force the creation of a new resource as this value can only be changed when a database is created. Defaults to en_US.utf8"
  type        = string
  default     = "en_US.utf8"
}

variable "lc_ctype" {
  description = "Character classification (LC_CTYPE) to use in the database. This affects the categorization of characters, e.g. lower, upper and digit. If unset or set to an empty string the default character classification is set to C. If set to DEFAULT Terraform will use the character classification of the specified template database. Changing this value will force the creation of a new resource as this value can only be changed when a database is created. Defaults to en_US.utf8."
  type        = string
  default     = "en_US.utf8"
}

variable "grants" {
  description = <<EOT
  <br><b>description:</b> Description of privileges.
  <br><b>role:</b> The name of the role to grant privileges on, Set it to "public" for all roles.
  <br><b>privileges:</b> The list of privileges to grant. There are different kinds of privileges: CREATE, CONNECT and TEMPORARY. An empty list could be provided to revoke all privileges for this role.
EOT
  type        = list(object({
    description = string
    role        = string
    privileges  = list(string)
  }))
  default = []

  validation {
    condition = alltrue(flatten([
      for k in var.grants :flatten([for v in k["privileges"] : contains(["CONNECT", "TEMPORARY", "CREATE"], v)])
    ]))
    error_message = "The privileges value must be one of CONNECT, TEMPORARY or CREATE."
  }
}