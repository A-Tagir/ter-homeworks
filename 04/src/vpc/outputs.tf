output "yandex_network_id" {
  value = yandex_vpc_network.develop.id
}

output "subnet_id_a" {
  value = yandex_vpc_subnet.develop_a.id
}

output "subnet_id_b" {
  value = yandex_vpc_subnet.develop_b.id
}
