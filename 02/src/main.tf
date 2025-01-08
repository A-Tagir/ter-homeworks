resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  #family = "ubuntu-2004-lts"
  family = var.vm_web_family
}

resource "yandex_compute_instance" "platform" {
  #name        = "netology-develop-platform-web"
  name         = local.name_web
  #platform_id = "standard-v1"
  platform_id  = var.vm_web_platform_id

  resources {
    #cores         = 2
    cores = var.vms_resources.web.cores
    #memory        = 1
    memory = var.vms_resources.web.memory
    #core_fraction = 5
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    #preemptible = true
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    #nat       = true
    nat = var.vm_web_nat

  }

  metadata = {
    serial-port-enable = var.metadata_resources.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
  }

}

resource "yandex_vpc_subnet" "develop_b" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_default_cidr
}

resource "yandex_compute_instance" "platform1" {
  name         = local.name_db
  platform_id  = var.vm_db_platform_id
  zone         = var.vm_db_zone

  resources {
    cores = var.vms_resources.db.cores
    memory = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat = var.vm_db_nat

  }

    metadata = {
    serial-port-enable = var.metadata_resources.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
  }

}


