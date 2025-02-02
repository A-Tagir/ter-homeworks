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

* Солгасно заданию добавил файл locals.tf где объявил локальную переменную ssh_key и c помощью функции filе
    присвоил ей значение считанное из локального файла содержащего публичный ключ:

 [locals.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/locals.tf)

 Далее во всех metadata контейнеров обращаюсь к этой переменной.

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

### 1
* Копируем из demo ansible.tf, hosts.tftpl, inventory.tf
* Вносим необходимые правки согласно заданию.
  [ansible.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/ansible.tf)

  [hosts.tftpl](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/hosts.tftpl)

* Блок storage в hosts.tftpl дополнен проверкой типа переменной yandex_compute_instance.storage
   и условием, что там может быть несколько инстансов.
  Результат:

  [hosts.cfg](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/hosts.cfg)

  


* Выполняем код
  Получаем ошибку при создании виртуальных дисков 1ГБ, что виртуальный диск не может быть менее 5ГБ.
  В файле disk_vm в конфигурации yandex_compute_disk 
  убираем заданное image_id (которое, видимо, не нужно и является причиной ограничения)

![Task4_disk_error](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_VM_disks_error.png)

* Повторно делаем apply

![apply_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_final_apply.png)

Здесь отображает создано 6, потому что остальные созданы раннее до ошибки создания дисков.

* Проверяем в веб-консоли, что VM созданы:

![vm_created_console](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_VM_created_web_console.png)

* Проверям файл hosts.cfg:

![hosts.cfg](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_hosts_cfg_ok.png)

* Созданные диски в веб-консоли

![disks_console](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_VM_disks.png)

* Удаляем ресурсы

terraform destroy -var "token=t1.XXXXXXXXXXX"

![destroyed](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task4_destroyed.png)

Все удалилось.

## Задание 5
* Создаем outputs.tf:
[outputs.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/03/src/outputs.tf)

* Делаем apply
  
  ![outputs](https://github.com/A-Tagir/ter-homeworks/blob/main/03/TerrHomework3_task5_output.png)

  Результат не совсем как нужно, но уже дедлайн. Видел, что нужно использовать flatten. Поразбираюсь позже.