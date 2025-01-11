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

Файл terraform.tfvars:

```
vm_web_resources = {
  cores = 2
  core_fraction = 5
  memory = 1
  preemptible = "true"
  nat = "false"
}

vm_web_metadata = {
  serial-port-enable = "true"
}

each_vm = [
  {
    vm_name = "main"
    cpu   = 4
    ram  = 2
    disk_volume = 5
    core_fraction = 20
    preemptible = true
    nat=false
    serial-console = 1
  },
  {
    vm_name="replica"
    cpu   = 2
    ram  = 1
    disk_volume = 10
    core_fraction = 5
    preemptible = true
    nat=false
    serial-console = 1
  }
```

* Инициализируем и apply

![VMs_created](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task2_VMs_created.png)

Смотрим через веб-консоль результат:

![VMs_console](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task2_VMs_y_console.png)

## Задание 3

### 1
* Создаем файл disk_vm.tf согласно заданию и добавляем нужные переменные в variables.tf:
[disk_vm.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/disk_vm.tf)

[variables.tf Task 3_1](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/variables.tf)

в terraform.tfvars добавляем параметры

```

disk_resources = {
  size = 1
  type = "network-hdd"
}

```
Проверяем 

![disks_plan](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task3_disks_plan.png)

### 2
* Согласно заданию создаем одиночную машину storage и подключаем к ней созданные диски 
  с использование блока dynamic secondary_disk{..}
  для этого в terraform.tfvars указываем параметры ВМ storage и дисков
```
storage_resources = {
  vm_name = "storage"
  cpu   = 2
  ram  = 1
  disk_volume = 5
  core_fraction = 5
  preemptible = true
  nat=false
  serial-console = 1
  disk_auto_delete = true
}
```
disk_auto_delete = true чтобы при удалении машин, диски также удалились
(или они все равно удалятся при terraform destroy? проверю позже)

[disk_vm.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/disk_vm.tf)

* проверяем (terraform plan -var "token=t1XXXXXXXXX")

![secondary_disks_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task3_secondary_dynamics.png)

Видим, что ошибки не найдены, диски должны подключиться.

## Задание 4


