# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

## Задание 1
* Чек лист выполнен
* Репозиторий с кодом выполненного задания:

[terraform 3 homework repo](https://github.com/A-Tagir/ter-homeworks/tree/main/03/src)

* Инициализируем проект
  
  yc iam create-token

  terraform init   

  terraform apply -var "token=t1.XXXXXXXX"

  Секьюрити группы созданы:

  ![dynamic_sec_grp_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_dinamic_sec_grp.png)

## Задание 2
### 1
* Создал файл count-vm.tf c описание VM согласно заданию:

[count-vm.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/count-vm.tf)

Проверяем 

terraform plan -var "token=t1.XXXXXXXXXXXXX"

![plan_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task1_VM_sec_group.png)

### 2
* Создал файл each-vm.tf в котором описал создание двух ВМ с помощью for_each loop:

[each-vm.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/for_each-vm.tf)

* добавил в count-vm.tf
```
 depends_on = [yandex_compute_instance.db]
```
Чтобы db запускались первыми.

* в main.tf добавил data local_file чтобы использовать публичный ключ 

 [main.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/main.tf)

* Инициализируем и apply

![VMs_created](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task2_VMs_created.png)

Смотрим через веб-консоль результат:

![VMs_console](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task2_VMs_y_console.png)

## Задание 3


