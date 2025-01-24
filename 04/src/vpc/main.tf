#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = var.vpc_name_a
  zone           = var.vpc_zone_a
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vpc_cidr_a
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = var.vpc_name_b
  zone           = var.vpc_zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vpc_cidr_b
}

