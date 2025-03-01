resource "postgresql_database" "main" {
  name            = var.name
  owner           = var.owner
  tablespace_name = var.tablespace_name

  connection_limit  = var.connection_limit
  allow_connections = var.allow_connections

  is_template = var.is_template
  template    = var.template

  encoding   = var.encoding
  lc_collate = var.lc_collate
  lc_ctype   = var.lc_ctype
}

resource "postgresql_grant" "name" {
  for_each = { for v in var.grants : v.description => v }

  database    = postgresql_database.main.name
  object_type = "database"
  role        = each.value["role"]
  privileges  = each.value["privileges"]
}
