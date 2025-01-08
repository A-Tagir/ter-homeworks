output "vm_web_external_ip_address" {
  value = [
            yandex_compute_instance.platform.name,
            yandex_compute_instance.platform.network_interface.0.nat_ip_address,
            yandex_compute_instance.platform.fqdn
          ]
  description = "vm web external ip"
}

output "vm_db_external_ip_address" {
  value = [
            yandex_compute_instance.platform1.name,
            yandex_compute_instance.platform1.network_interface.0.nat_ip_address,
            yandex_compute_instance.platform1.fqdn
          ]
  description = "vm db external ip"
}
