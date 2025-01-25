# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

## Задание 1
* Чек лист выполнен
* Репозиторий с кодом выполненного задания:

[terraform 4 homework repo](https://github.com/A-Tagir/ter-homeworks/tree/main/04/src)

* Инициализируем проект
  
  yc iam create-token

  terraform init   

  terraform apply -var "token=t1.XXXXXXXX"

* Согласно заданию 1 правим cloud-init.yaml и main.tf. Для ssh ключа создаем locals.tf 

[main.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/04/src/main.tf)

[cloud-init.yaml](https://github.com/A-Tagir/ter-homeworks/blob/main/04/src/cloud-init.yml)

[variables.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/04/src/variables.tf)
```
personal.auto.tfvars
cloud_id  = "XXXXXXXXXXXXX"
folder_id = "XXXXXXXXXXXXX"
vm_username = "tiger"

```
* terraform apply -var "token=t1.XXXXXXXXXXXXXXXXXX"

![vms_created](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_task1_created.png)

* terraform console

module.marketing-vm

![module_marketing-vm](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_module_marketing-vm.png)

module.marketing-vm

![module_accounting-vm](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_module_accounting-vm.png)

* подключаемся к внешнему IP VM с помощью публичного ключа и вызываем sudo nginx -t
  
  ![nginx_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_task1_nginx_ok.png)


## Задание 2

* Создаем папку vpc и все необходимые файлы:
  
  [vpc-module](https://github.com/A-Tagir/ter-homeworks/tree/main/04/src/vpc)

* ресурсы заменил сетями из модуля, прежние закомментировал.

* Делаем init и apply

![apply_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_task2_apply_ok.png)

* вызываем консоль
  
![console_module](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_task2_console_module.png)

* Генерируем доки

```

docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > README.md

```

[vpc-develope-docs](https://github.com/A-Tagir/ter-homeworks/blob/main/04/src/vpc/README.md)


## Задание 3

* Выполняем terraform state list:

```
terraform state list
data.template_file.cloudinit
module.accounting-vm.data.yandex_compute_image.my_image
module.accounting-vm.yandex_compute_instance.vm[0]
module.accounting-vm.yandex_compute_instance.vm[1]
module.marketing-vm.data.yandex_compute_image.my_image
module.marketing-vm.yandex_compute_instance.vm[0]
module.vpc-develope.yandex_vpc_network.develop
module.vpc-develope.yandex_vpc_subnet.develop_a
module.vpc-develope.yandex_vpc_subnet.develop_b
```
* Удаляем модули

```
terraform state rm module.vpc-develope
Removed module.vpc-develope.yandex_vpc_network.develop
Removed module.vpc-develope.yandex_vpc_subnet.develop_a
Removed module.vpc-develope.yandex_vpc_subnet.develop_b
Successfully removed 3 resource instance(s).

tiger@VM1:~/ter-homeworks/04/src$ terraform state rm module.marketing-vm
Removed module.marketing-vm.data.yandex_compute_image.my_image
Removed module.marketing-vm.yandex_compute_instance.vm[0]
Successfully removed 2 resource instance(s).

tiger@VM1:~/ter-homeworks/04/src$ terraform state rm module.accounting-vm
Removed module.accounting-vm.data.yandex_compute_image.my_image
Removed module.accounting-vm.yandex_compute_instance.vm[0]
Removed module.accounting-vm.yandex_compute_instance.vm[1]
Successfully removed 3 resource instance(s).

tiger@VM1:~/ter-homeworks/04/src$ terraform state list
data.template_file.cloudinit

```

* Импортируем модули (id смотрим в консоли ycloud):
```
terraform import module.vpc-develope.yandex_vpc_network.develop enpqc6nq72eu29nvciff

terraform import module.vpc-develope.yandex_vpc_subnet.develop_a e9brtkmp06k0do9pcha4

terraform import module.vpc-develope.yandex_vpc_subnet.develop_b e2l8cgjnagok3bc0acpj

terraform import module.accounting-vm.yandex_compute_instance.vm[0] fhm2gt15eji259tqjehk

terraform import module.accounting-vm.yandex_compute_instance.vm[1] epd16ih10p15oq3ipf14

terraform import module.marketing-vm.yandex_compute_instance.vm[0] fhmae9gsa2rq4mo162qm

```

* Теперь 
```
terraform state list
data.template_file.cloudinit
module.accounting-vm.data.yandex_compute_image.my_image
module.accounting-vm.yandex_compute_instance.vm[0]
module.accounting-vm.yandex_compute_instance.vm[1]
module.marketing-vm.data.yandex_compute_image.my_image
module.marketing-vm.yandex_compute_instance.vm[0]
module.vpc-develope.yandex_vpc_network.develop
module.vpc-develope.yandex_vpc_subnet.develop_a
module.vpc-develope.yandex_vpc_subnet.develop_b
```

* Выполняем terraform plan

![import_and_plan](https://github.com/A-Tagir/ter-homeworks/blob/main/04/TerrHomework4_task3_import_plan.png)

Названия и ID совпадают, но пишет что будут обновлены. Видимо, это норма. Выполняем.







