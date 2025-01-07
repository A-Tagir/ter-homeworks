### Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

* Чек лист выполнен, с документацией по yandex security group ознакомился.

### Задание 1

* Создаю сервисный аккаунт netohomworktf2

![service_account](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_service_acc.png)

* переменные cloud_id, foulder_id, vms_ssh_root_key добавляю в personal.auto.tfvars
  
* создаем IAM-token

yc iam create-token

* полученный токен сохраняем в надежном месте и далее используем для работы terraform с ya cloud.

* комментируем в providers.tf строку  service_account_key_file , поскольку для авторизации я планирую
  использовать token. Добавляю переменную token в variables.tf и providers.rf

  provider "yandex" {

  **token                    = var.token**

  cloud_id                 = var.cloud_id

  folder_id                = var.folder_id

  zone                     = var.default_zone

  # service_account_key_file = file("~/.authorized_key.json")
  }
