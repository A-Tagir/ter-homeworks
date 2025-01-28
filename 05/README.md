# Домашнее задание к занятию «Использование Terraform в команде»

## Задание 1
* Чек лист выполнен
* Репозиторий с кодом выполненного задания:

[terraform 5 homework repo](https://github.com/A-Tagir/ter-homeworks/tree/main/05/src)

* Клонируем репозиторий, чтобы извлечь код из ДЗ и демо лекции 4
  git clone https://github.com/netology-code/ter-homeworks.git origin-ter

* копируем в папку ter-homeworks/tree/main/05/src и запускаем там tflint

docker run --rm -v "$(pwd):/tflint" ghcr.io/terraform-linters/tflint --chdir /tflint

Также запускаем tflint в папках из демо vms и password

Находит следующие виды ошибок:

1 - не указан диапазон версий для провайдера  (могут быть проблемы с совместимостью)

2 - переменная объявлена но не используется (unused declarations)

3 - исходный код модуля использует ветвь по умолчанию как основную. Хоть это и
допустимо, рекомендуется зафиксировать конкретную версию, чтобы обеспечить стабильность.


* проверяем программой chekov
  
  docker run --rm --tty --volume $(pwd):/tf --workdir /tf bridgecrew/checkov --download-external-modules true --directory /tf

  в коде 04/src и 04/demonstration1/passwords замечаний нет.

  в коде 04/demonstration1/vms замечания следующие:

1 - Не назначена группа безопасности для сетевого интерфейса

2 - Инстанс имеет публичный IP адрес

3 - Для указания пути к исходному коду модуля не используется хэш-коммит

4 - Для указания пути к исходному коду модуля не используется тег с номером версии


## Задание 2

* Создаю новую ветку     git branch terraform-05
  Переключаюсь           git switch terraform-05

  git push origin terraform-05

* Согласно заданию создаем в ycloud  хранилище free tire Object Storage backet 1ГБ
* Создаем базу YDB и таблицу tfstate-table
* Создаем сервисный аккаунт, создаем ключ.
* Даем права доступа READ/WRITE для Storage и YDB

Добавляем в main.tf блок s3 backet

[main.tf](https://github.com/A-Tagir/ter-homeworks/blob/terraform-05/05/src/main.tf)

* Выполняем terraform init   

```
 terraform init -backend-config="access_key=XXXXXXXXXXXXXX" -backend-config="secret_key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

* Теперь добавляем dinamodb)endpoint

```

terraform init -migrate-state -backend-config="access_key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" -backend-config="secret_key=XXXXXXXXXXXXXXXXXXXXXXX"

```

terraform console и в другом окне еще раз вызываем:

![state_locked](https://github.com/A-Tagir/ter-homeworks/blob/terraform-05/05/TerrHomework5_task2_state_lock.png)

* Видим что при вызове второй консоли ошибка.

* Разблокируем:

terraform force-unlock d3aca172-f7f8-4fa4-bf59-0334f5b610b5

Консоль разблокируется.
















