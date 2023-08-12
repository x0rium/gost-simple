# gost-simple

Отличный вариант легковесного скоростного туннеля по Gost'у без дополнительного шифрования.

Скрипт разворачивает сервер gost reply + web socket.

Чтобы развернуть надо запустить deploy.sh и ответить на вопросы.

```shell
git clone https://github.com/x0rium/gost-simple.git

cd gost-simple

sudo bash deploy.sh
```


Конфиг сервера доступен в файле /opt/gost3/gost.yaml

Вот тут можно добавить столько юзеров сколько надо,

auths:
- username: username1
  password: pass
- username: username2
  password: pass2


Включен режим хот релоада конфигурации - данные из конфига будут применяться раз в десять секунд, перезагружать сервис не надо.




