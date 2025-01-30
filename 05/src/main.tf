#создаем облачную сеть 
#resource "yandex_vpc_network" "develop" {
#  name = "develop"
#}

#создаем подсеть
#resource "yandex_vpc_subnet" "develop_a" {
#  name           = "develop-ru-central1-a"
#  zone           = "ru-central1-a"
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = ["10.0.1.0/24"]
#}

module "vpc-develope" {
  source         = "./vpc"
  env_name = "develope"
  vpc_name_a = "develop-ru-central1-a"
  vpc_zone_a = "ru-central1-a"
  vpc_cidr_a = ["10.0.1.0/24"]
  vpc_name_b = "develop-ru-central1-b"
  vpc_zone_b = "ru-central1-b"
  vpc_cidr_b = ["10.0.2.0/24"]
}

#resource "yandex_vpc_subnet" "develop_b" {
#  name           = "develop-ru-central1-b"
#  zone           = "ru-central1-b"
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = ["10.0.2.0/24"]
#}


module "accounting-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc-develope.yandex_network_id
  subnet_zones   = ["ru-central1-a","ru-central1-b"]
  subnet_ids     = [module.vpc-develope.subnet_id_a,module.vpc-develope.subnet_id_b]
  instance_name  = "webs"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner = var.vm_owner
    project = var.vm_accounting_project
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "marketing-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.vpc-develope.yandex_network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc-develope.subnet_id_a]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner = var.vm_owner
    project = var.vm_marketing_project
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

terraform {

  backend "s3" {
  endpoints = { s3 = "https://storage.yandexcloud.net" }
  bucket = "tfstate-devel"
  region = "ru-central1-a"
  key = "terraform.tfstate"
  
  skip_region_validation = true
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_s3_checksum = true
  
  dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g4vhlfnuf4ep5dnei1/etn8driiai5oekndkl37"
  dynamodb_table = "tfstate-table"
}
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  
  vars = {
  username = var.vm_username
  ssh_public_key = local.vms_ssh_root_key
 }
}

