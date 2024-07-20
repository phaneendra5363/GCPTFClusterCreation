resource "google_sql_database_instance" "instance" {
  name             = "hello-world-db"
  database_version = "MYSQL_5_7"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "hello_world"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "user"
  instance = google_sql_database_instance.instance.name
  password = "password"
}
