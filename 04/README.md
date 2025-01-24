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

