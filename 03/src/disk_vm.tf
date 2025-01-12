resource "yandex_compute_disk" "disk" {
  count = 3
  name = "disk-${count.index+1}"
  size = var.disk_resources.size
  type = var.disk_resources.type
  zone = var.default_zone
#  image_id = data.yandex_compute_image.ubuntu.image_id
  labels = {
   environment = "disk-${count.index+1}"
  }
}

resource "yandex_compute_instance" "storage" {

  name = var.storage_resources.vm_name
  platform_id  = var.vm_web_platform_id

  resources {
    cores = var.storage_resources.cpu
    memory = var.storage_resources.ram
    core_fraction = var.storage_resources.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.storage_resources.disk_volume
    }
  }

  dynamic secondary_disk {
    for_each = yandex_compute_disk.disk[*]
    content {
      disk_id = secondary_disk.value.id
      auto_delete = var.storage_resources.disk_auto_delete
  }
  
  }

  scheduling_policy {
    preemptible = var.storage_resources.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.storage_resources.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = var.storage_resources.serial-console
    ssh-keys           = data.local_file.ssh-key.content
  }

}

