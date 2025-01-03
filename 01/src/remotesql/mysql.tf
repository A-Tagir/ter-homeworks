terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  host = "ssh://tiger@51.250.7.170"
}

#однострочный комментарий


resource "random_password" "random_string" {
  length      = 16
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "random_string1" {
  length      = 16
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "mysql8" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql8" {
  image = docker_image.mysql8.image_id
  name  = "mysql8"
  env = ["MYSQL_ROOT_PASSWORD=${random_password.random_string.result}", "MYSQL_DATABASE=wordpress", "MYSQL_USER=wordpress", "MYSQL_PASSWORD=${random_password.random_string1.result}", "MYSQL_ROOT_HOST=%"]
  ports {
    internal = 3306
    external = 3306
    ip = "127.0.0.1"
  }
}
