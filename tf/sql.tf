resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = "false"
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = var.user
  instance = google_sql_database_instance.instance.name
  password = var.pwd
}


