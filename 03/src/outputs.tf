output "vm_web_data" {
  value = [
            yandex_compute_instance.web[*].name,
            yandex_compute_instance.web[*].id,
            yandex_compute_instance.web[*].fqdn
          ]
  description = "vm web name id fqdn"
}


output "vm_db_name" {
  value = [
           for db in yandex_compute_instance.db : db.name
          ]
  description = "vm db name"
}

output "vm_db_id" {
  value = [
           for db in yandex_compute_instance.db : db.id
          ]
  description = "vm db id"
}

output "vm_db_fqdn" {
  value = [
           for db in yandex_compute_instance.db : db.fqdn
          ]
  description = "vm db fqdn"
}

output "vm_storage_data" {
  value = [
            yandex_compute_instance.storage.name,
            yandex_compute_instance.storage.id,
            yandex_compute_instance.storage.fqdn
          ]
  description = "vm storage name id fqdn"
}
