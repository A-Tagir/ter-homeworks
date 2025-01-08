# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

* Чек лист выполнен, с документацией по yandex security group ознакомился.

## Задание 1

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

  \# service_account_key_file = file("~/.authorized_key.json")
  }

* Делаем terraform validate и получаем ошибку что в провайдере необходим либо key либо token

![validate_plan](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_validate.png)

* Передаем токен из командной строки:

terraform plan -var "token=XXXXXXX"

![plan_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_plan1.png)

* Теперь apply 

terraform apply -var "token=XXXXXXX"

Но получили ошибку что квота на виртуальные сети превышена. 
Это случилось потому что не удалены сети из предыдущей домашней работы. 

![quote_exceed](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_apply1.png)

Удаляем из веб-консоли и пробуем снова. 

* Теперь выдает что платформа standar**t**-v4 не поддерживается. Находим в документации облака,
  что платформы standard-v1, standard-v2 и standard-v3. Исправляем опечатки и пробуем еще.
  Выбираем standard-v1 поскольку только там поддерживается core fraction 5.
  Исправляем в main.tf и значение core на 2, поскольку core=1 недоступно для платформы standard-v1.

  ![ok_at_last](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_apply_ok.png)

* Теперь мы видим, что виртуальная машина создалась

 ![vm_ok_ip](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_vm_ok.png)

* Подключаемся по ssh сначала неудачно, потому что имя tiger (мы еще не умеем делать имена), правим на ubuntu и теперь успешно.
  Видим, что curl ifconfig.me отработал, также, успешно:

 ![ssh_curl_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_vm_ssh.png)

 * Параметры виртуальной машины preemptible = true означает, что это прерываемая ВМ. Если возникнет необходимость
  освободить ресурсы для более приоритетных ВМ, машина будет остановлена (с коротким уведомлением). Это используется
  для максимально низкой цены и приемлемо для учебных и тестовых стендов.
 * Параметр core_fraction = 5 означает что только 5% процессорного времени будет доступно для задач.
   Это также означает минимальную стоимость ВМ и удобно для тестовых и учебных задач, когда не нужно много 
   процессорного времени.

## Задание 2

* Заменяем хард-код значения переменными:

```
data "yandex_compute_image" "ubuntu" {
  #family = "ubuntu-2004-lts"
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  #name        = "netology-develop-platform-web"
  name         = var.vm_web_name
  #platform_id = "standard-v1"
  platform_id  = var.vm_web_platform_id
  resources {
    #cores         = 2
    cores = var.vm_web_cores
    #memory        = 1
    memory = var.vm_web_memory
    #core_fraction = 5
    core_fraction = var.vm_web_core_fraction
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
    #serial-port-enable = 1
    serial-port-enable = var.vm_web_serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```
* Проверяем результат и видим, что No changes:

![no_hardcode_no_changes](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_plan_no_hardcoding.png)

## Задание 3

* Копируем файл variables.tf c новым именем vms_platform.ts, убираем ненужные переменные (чтобы не дублировались) и создаем новые vm_db_
* в файле main.ts создаем новый subnet для зоны central1-b 
* в файле main.ts копируем ресурс yandex_compute_instance и переименовываем переменные на новые.
* в personal.auto.tfvars пишем нужные значения переменных, согласно заданию.
  Делаем 

terraform apply -var "token=XXXXXXX"

Ресурсы создаются:

![Second VM zone B](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_vm_second_vm_zoneB.png)

Также файлы tf:

[main.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/02/src/main.tf)
[variables.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/02/src/variables.tf)
[vms_platform.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/02/src/vms_platform.tf)

Все переменные в personal.auto.tfvars который в git не отправляем.

## Задание 4

* создаем вывод для каждой ВМ в файле outputs.tf
  [outputs.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/02/src/outputs.tf)

* создаем новый токен, потому что вчерашний уже не действует
  yc iam create-token

* применяем 

terraform init
terraform apply -var "token=t1.XXXXXXXXXXXXXXXXXXX"

![apply_with_outputs](https://github.com/A-Tagir/ter-homeworks/blob/main/02/TerrHomework2_outputs.png)

terraform output 

также выводит требуемые в задании 4 значения.

## Задание 5





