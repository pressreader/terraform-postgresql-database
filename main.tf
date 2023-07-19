resource "postgresql_database" "main" {
  name  = var.name
  owner = var.owner

  connection_limit  = var.connection_limit
  allow_connections = var.allow_connections

  is_template = var.is_template
  template    = var.template

  encoding   = var.encoding
  lc_collate = var.lc_collate
  lc_ctype   = var.lc_ctype
}

resource "postgresql_grant" "name" {
  for_each = {
    for v in var.grants :
    length(v["privileges"]) != 0 ?
    "${v["role"]} | ${v["privileges"]}" :
    "${v["role"]} | REVOKE"
    => v
  }

  database    = postgresql_database.main.name
  object_type = "database"
  role        = each.value["role"]
  privileges  = each.value["privileges"]
}