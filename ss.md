## Shadowsocks не по стелсу

Из за временных блокировок вижу кучу интересных статей по поводу невероятности и необнаружимости сиего чудесного
протокола.
Но это не совсем так, а только при исползованиее стандартов протокола SIP004 и SIP007 с
шифрованием [AEAD](https://shadowsocks.org/doc/aead.html) и то весьма условно =)
Предлагаю немного погрузиться в будни китайских файрвольщиков и посмотреть на shadowsocks чуть подробнее.

Shadowsocks — это бесплатный проект протокола шифрования с открытым исходным кодом, который широко используется в Китае
для обхода интернет-цензуры.
Был создан в 2012 году китайским программистом по имени «Clowwindy», и с тех пор стало доступно несколько реализаций
протокола.

Он поддержкивает различные алгоритмы шифрования, и устроен таким образом чтобы его было дорого блокировать (с точки
зрения затраченных ресурсов).

При этом вся информация шифруется, в отличии от того же TLS (который передает некоторую органиченную часть инфы в
открытом виде).
Так сделали чтобы нельзя блыо составить простое регулярное выражение, выделяющее часть трафика.
И это работает, но на каждую хитрую рожу найдется свой особо кислый лимон.

Предлагаю обратиться к опыту коллег, изучающих работы китайского файрволла. Они выпустили занимательный ресерч в котором
описываю как именно
[происходит обнаружение серверов Shadowsocks](https://gfw.report/publications/imc20/data/paper/shadowsocks.pdf).

Если кратко то абузится печально известная методика [active probing](https://ensa.fi/active-probing/) , давай
разберемся что же это такое.

Active Probing (активное зондирование)  - это методика, при которой система активно взаимодействует с подозрительным
сервисом, например пытаясь определить его "цифровой отпечаток" по поведению и метрикам.
При этом подключения к серверу могут происходить из
разных подсетей, могут применяться различные техники отправки
заведомо ошибочных пакетов. В итоге поведение сервиса, время ответа, возможные ошибки и прочая добытая информация
подвергаются
анализу и может применятся для поиска по базе эвристик сервисов. Технология не новая и давно применяется в сканерах
уязвимостей.

Ресерчеры разместили свои серверы Shadowsocks, конектились к ним из Китая и наблюдали как медлленно и элегантно
блокируются их серваки. Но дело было сделано, удалось собрать информации о технике обнаружения.

Как происходит обнаружение?

Первый шаг - выделение потенциального таргета

- анализ энтропии соединения
- анализ длины пакетов

Второй шаг - подтверждение

- Коннект к серверу от имени своего или чужого ip с использованием протокла Shadowsocks
- Анализ отевета

Почему два шага? Дело в том что блокировать все полностью зашифрованные соединения без разбора через чур больно для
юзеров. Через второй шаг минимизируют ошибки обнаружения и могут блокировать с довольно вменяемой точностью.

После выявления обычно включается небольшой лаг необходимый для отслеживания а куда же хитрый юзер еще коннектится,
затем блокировка.

И вроде даже разработчики предприняли шаги по фиксу этого обнаружение, но помогло
слабо.

Так же стоит упомянуть косяк с шифрованием который вскрылся не так давно, из за особенности криптографии которая
применялась можно было довольно успешно детектить shadowsocks, что послужило поводом для резкого переезда
на [AEAD шифрование](https://web.archive.org/web/20191002190325/https://printempw.github.io/why-do-shadowsocks-deprecate-ota/),
что послужило появлению новых стандартов [SIP007](https://github.com/shadowsocks/shadowsocks-org/issues/42)
и [SIP004](https://github.com/shadowsocks/shadowsocks-org/issues/30)

И только расслабили булки, наслаждаясь победой как
случается [SSAPPIDENTIFY](https://www.sciencedirect.com/science/article/abs/pii/S1389128621005387)

```
SS прост в развертывании, имеет хорошее качество связи, надежную анонимность, высокий уровень безопасности и непрост для мониторинга. Таким образом, он часто используется для проникновения через брандмауэры и обхода контроля и проверки. Это позволяет преступникам заниматься кражей данных, порнографией и Интернетом. 

Чтобы эффективно контролировать, отслеживать и получать доказательства киберпреступной деятельности, необходим эффективный метод идентификации потока для SS. В настоящее время имеется литература по идентификации трафика АС [2], [3], [4], и получены хорошие результаты. Однако из-за широкого использования SS в настоящее время одной идентификации трафика SS недостаточно для обеспечения быстрого наблюдения и сбора доказательств.

С другой стороны, мобильный интернет-трафик Китая занимает подавляющее большинство, и использование SS на мобильных устройствах очень распространено, что также делает использование мобильных устройств для участия в преступной деятельности все более и более частым. 

Если известно, что преступники используют определенные приложения (приложения) для участия в незаконных действиях, то дальнейшая идентификация соответствующего трафика приложений из большого объема захваченного трафика SS, очевидно, будет более полезна для дальнейшего нацеливания на преступников. 

Поэтому трафик SS должен быть дополнительно соотнесен с его источником приложения, чтобы спряташихся в нем нелегальных сетевых активистов можно было быстро и точно найти из большого количества обычных пользователей, ведущих нормальную сетевую деятельность.
```

Да да, мой дорогой юзернейм, твои глаза не поломались, определение приложения по шфированному трафлу 🔮

Ты думаешь это все ? Нет нет нет )) Выходит замечательный
ресерч [How the Great Firewall of China Detects and Blocks Fully Encrypted Traffic](https://gfw.report/publications/usenixsecurity23/en/)
представленный на
тусовке [USENIX Security Symposium 2023](https://www.usenix.org/conference/usenixsecurity23/fall-accepted-papers) (
кстати по ссылке список докладов, рекомендую ознакомится). Вот краткий перевод интро:

```
Одним из краеугольных камней в. обходе цензуры являются полностью зашифрованные протоколы, которые шифруют каждый байт полезной нагрузки в попытке «выглядеть как ничто». В начале ноября 2021 года Великий брандмауэр Китая (GFW) развернул новую технику цензуры, которая пассивно обнаруживает и впоследствии блокирует полностью зашифрованный трафик в режиме реального времени.

Новая возможность цензуры GFW влияет на большой набор популярных протоколов обхода цензуры, включая, помимо прочего, Shadowsocks, VMess и Obfs4. Хотя Китай уже давно активно исследует такие протоколы, это был первый отчет о чисто пассивном обнаружении, что заставило антицензурное сообщество задаться вопросом, как такое обнаружение возможно.

В этой статье мы измеряем и описываем новую систему GFW для цензуры полностью зашифрованного трафика. Мы обнаружили, что вместо прямого определения полностью зашифрованного трафика цензор применяет грубую, но эффективную эвристику для исключения трафика, который вряд ли является полностью зашифрованным трафиком; затем он блокирует оставшийся неосвобожденный трафик. 

Эти эвристики основаны на отпечатках распространенных протоколов, доле установленных битов, а также количестве, доле и позиции печатаемых символов ASCII. Наше интернет-сканирование показывает, какой трафик и какие IP-адреса проверяет GFW. Мы моделируем предполагаемый алгоритм обнаружения GFW на живом трафике в сети университета, чтобы оценить его полноту и ложные срабатывания.

Мы приводим доказательства того, что выведенные нами правила хорошо охватывают то, что на самом деле использует GFW. По нашим оценкам, при широком применении он потенциально может заблокировать около 0,6% обычного интернет-трафика в качестве побочного ущерба.
```

Вообще это повествование можно продолжать бесконечно , но думаю представленной информаци будет достаточно
чтобы сделать кое какие выводы.

Как и в остальных сферах отрасли мы наблюдаем "борьбу меча и щита", и никакой панацеей Shadowsocks не является.

Что же до наших местных реалий - можно выделить некоторые рекомендации по настройке shadowsocks, которые минимизируют
вероятность возможного обнаружения.

- используй shadowsocks + тонель, например web socket через v2ray или что то похожее
- обязательно юзай [AEAD](https://shadowsocks.org/doc/aead.html)  а конкретно один из алгоритмов,
    - AEAD_CHACHA20_POLY1305 он же chacha20-ietf-poly1305
    - AEAD_AES_256_GCM он же aes-256-gcm
    - AEAD_AES_128_GCM он же aes-128-gcm
      кроме буста к скрытности получишь буст жизни аккумулятора на своих потабельных девайсах
- используй свежие сборки серверов и клиентов, поддерживающие SIP004 или SIP007

На этом прощаюсь и до новых встреч.
