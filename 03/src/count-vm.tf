resource "yandex_compute_instance" "web" {
  count = 2
  name = "web-${count.index+1}"
  platform_id  = var.vm_web_platform_id

  resources {
    cores = var.vm_web_resources.cores
    memory = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_resources.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_web_resources.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = var.vm_web_metadata.serial-port-enable
    ssh-keys           = data.local_file.ssh-key.content
  }

  depends_on = [yandex_compute_instance.db]

}

