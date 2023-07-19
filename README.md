# PostgreSQL Database Terraform module

Terraform module which creates Database in PostgreSQL

## Usage

```terraform
module "database" {
  source = "git::https://github.com/pressreader/terraform-postgresql-database.git?ref=v1.0.0"

  name  = "Name of a database"
  owner = "Owner of the database" # Defaults to null

  connection_limit  = 1000 # Defaults to -1
  allow_connections = true # Defaults to true

  is_template = false       # Defaults to false
  template    = "template0" # Defaults to template0

  encoding   = "UTF8"       # Defaults to UTF8
  lc_collate = "en_US.utf8" # Defaults to en_US.utf8
  lc_ctype   = "en_US.utf8" # Defaults to en_US.utf8

  # Defaults to []
  grants = [
    {
      role       = "public"
      privileges = [] # Revoke all privileges from public
    }
  ]
}
```