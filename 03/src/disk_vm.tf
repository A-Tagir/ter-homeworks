resource "yandex_compute_disk" "disk" {
  count = 3
  name = "disk-${count.index+1}"
  size = var.disk_resources.size
  type = var.disk_resources.type
  zone = var.default_zone
  image_id = data.yandex_compute_image.ubuntu.image_id
  labels = {
   environment = "disk-${count.index+1}"
  }
}
