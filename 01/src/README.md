###
Домашнее задание к занятию «Введение в Terraform»
###
##
Подготовка
##
* Скачиваю и распаковываю Terraform
  
   wget https://hashicorp-releases.yandexcloud.net/terraform/1.8.4/terraform_1.8.4_linux_amd64.zip

   unzip ./terraform_1.8.4_linux_amd64.zip

   cp ./terraform /usr/bin/
   
   terraform --version

        Terraform v1.8.4
        on linux_amd64
    Готово
* Делаем форк репозитория и далее
  
  git clone git@github.com:A-Tagir/ter-homeworks.git

#
Задание 1
#

* скачиваем все зависимости использованные в проекте:
  
  terraform init   (включаем обход блокировок иначе нет доступа)

![initialized](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_initialized.png)

* Изучаю файл .gitignore
  
  Для хранения паролей и чувствительных к компрометации переменных предназначен файл personal.auto.tvars
  он не будет загружаться в git репозиторий. 
  
  Также не будут загружаться файлы state с расширение tfstate, а также содержащие в названии tfstate.
  Это файлы текущего состояние проекта, их не следует компрометировать.
  
  Папка .terraform также исключена,  поскольку там храняться файлы и модули провайдеров, которые подтягиваются
  при иницииализации проекта. Их просто не нужно хранить в репозитории. 

* Проверяем конфигурацию

  terraform plan
  terraform validate  (помним, что при terraform plan, validate производится автоматически):

  ![terraform plan](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_plan.png)

* Запускаем проект

  terraform apply

  ![tf_apply](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_apply.png)

* смотрим созданный state:

  cat terraform.tfstate

  ![state](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_result.png)

  видим секретное содержимое  "result": "pUKM8ea56AgbAzxJ"
  но "special": false

* раскомментировал часть main.tf согласно заданию
  
  terraform validate
╷
│ Error: Missing name for resource

при объявлении ресурса resource "docker_image" указан тип ресурса, но не указано имя.
Исправляем resource "docker_image" "nginx"

Далее   

terraform validate

Error: Reference to undeclared resource
│
│   on main.tf line 31, in resource "docker_container" "nginx":
│   31:   name  = "example_${random_password.random_string_FAKE.resulT}"

Здесь выше обьявлен ресурс resource "random_password" "random_string"
поэтому исправляем строку 31 в котором ресурс используется

 name  = "example_${random_password.random_string.result}"

terraform validate

Success! The configuration is valid.

* Рабочая часть конфигурации после исправлений

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }

* запускаем 
  
  terraform apply

  ![docker_up](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_docker_up.png)

* Меняем имя docker-контейнера в блоке кода на hello_world:
  
 с   name  = "example_${random_password.random_string.result}"
 на  name  = "hello_world"

terraform apply -auto-approve

![renamed_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_container_rename.png)

Видим что все переименовалось корректно. 
Использование -auto-approve несет опасности, если предварительно не проверить конфигурацию с помощью plan.

Например, я перепутал и переименова имя образа. При этом не проверив запустил apply с -auto-approve.

Работающий контейнер был уничтожен, а новый не создался. Для работающего а не тестового проекта это
нежелательно и вызовет перерыв в обслуживании:

│ Error: Unable to create container: Error response from daemon: Conflict. The container name "/example_pUKM8ea56AgbAzxJ"
  is already in use by container "32a7fa97e9fd39d5755c16262177ef0c7cc39f3f8fc6f43889fec56489b44b0b". 
  You have to remove (or rename) that container to be able to reuse that name.

Ключ -auto-approve может быть необходим при написании скриптов, которые будут автоматически запускать проект 
или вносить изменения. При этом можно предусмотреть предварительную проверку с plan, парсинг ошибок итп.

* Уничтожаем проект

 terraform destroy

![tf_destroyed](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homwork6_terra_destroyed.png)

образ nginx        latest сохранился, поскольку есть директива в объявлении ресурса:

keep_locally = true

[docker_docs](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs/resources/image)

  keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation.
  If this is false, it will delete the image from the docker local storage on destroy operation.

##
Дополнительные задания
##

#
Задание 2
#

* Создаю ВМ в облаке яндекс через веб-консоль. 
![VM created](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homework6_terra_2_yacloud.png)
* Установил докер стек.
* пользователя ssh под которым происходит ssh подключение к remote docker context нужно добавить
  в группу docker, иначе не будет работать.
  sudo usermod -a -G docker tiger
  Далее на локальной машине
  
  docker context create terraform --docker "host=ssh://tiger@89.169.146.153"

  Поскольку docker использует локальный ssh клиент, то нужно подключиться и подтвердить хост:
  ssh tiger@89.169.146.153 

  "This key is not known by any other names.
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  Warning: Permanently added '89.169.146.153' (ED25519) to the list of known hosts"

  ![context_created](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/Homework6_terra_2_remote_context.png)

  видим, что удаленный контекст подключен.

* Создаем файл mysql.tf
[mysql.tf](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/remotesql/mysql.tf)

terraform apply

и далее проверяем:

![env_ok](https://github.com/A-Tagir/ter-homeworks/blob/main/01/src/remotesql/Homework6_terra_2_yacloud_env_ok.png)

Видим, что контейнер работает, mysql поднялся и переменные передались.