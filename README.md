# gost-simple

!!! В процессе отладки тестирования и исследования !!!

Отличный вариант легковесного скоростного туннеля по Gost'у =) без дополнительного шифрования. Хорошо работают звонки (тестировалаось Whatsapp, Telegram, Zoom)

Скрипт разворачивает сервер gost reply + web socket.

## Требования 
Debian , Ubuntu или подобная VPS с 100мб свободного диска и 100мб оперативной памяти, хорошо подойдут бюджетные VPS, к [примеру от iHor](https://www.ihor-hosting.ru/?from=180121).

## Установка 
Чтобы развернуть надо запустить deploy.sh и ответить на вопросы.

```shell
git clone https://github.com/x0rium/gost-simple.git

cd gost-simple

sudo bash deploy.sh
```

Конфиг сервера доступен в файле `/opt/gost3/gost.yaml`

В секции `auths` можно добавить столько юзеров сколько надо,

```
auths:
- username: username1
  password: pass
- username: username2
  password: pass2
```


Включен режим хот релоада конфигурации - данные из конфига будут применяться раз в десять секунд, перезагружать сервис не надо.

## Клиенты

Протестировано на iOS с приложением shdowrocket

addrees - ip адрес сервера
Port - который указан при установке
Password - пароль
Plugin - gost
Plugin -> gost -> Type - ws 
TCP Fast Open включен
UDP Relay включен

## Reference 

[Официальная докуемнтация GOST](https://gost.run/en/)

