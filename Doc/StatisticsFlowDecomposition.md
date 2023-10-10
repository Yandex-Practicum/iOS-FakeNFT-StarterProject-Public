Ветров Константин Валерьевич
<br /> Кагорта: 6
<br /> Группа: 5
<br /> Эпик: Статистика 
<br />ссылка на таск трекер: https://github.com/users/Skoch33/projects/2/views/1
<hr>
<b>ЗАМЕТКА<br />
<br />Модуль 1:
<br />Экран Рейтинг
<br />"Сверстать UI-Элементы"
<br />"Заполнить таблицу данными из сетевого слоя"
<br />"Передать данные пользователя в экран Резюме пользователя"
<br />
<br />Модуль 2:
<br />Экран Карточка пользователя
<br />"Сверстать UI-Элементы"
<br />"Заполнить UI-Элементы данными из экрана Рейтинг"
<br /> 
<br />Модуль 3:
<br />Экран Коллекция пользователя
<br />"Сверстать UI-Элементы"
<br />"Заполнить коллекцию данными из сетевого слоя MockAPI"
</i>

# Statistics Flow Decomposition


## Экран Rating (est 360; fact x).
### Module 1:

#### Верстка
- NavigationBar с кнопкой сортировки (est: 30 min; fact x min).
- Таблицы (est: 120 min; fact: x min).
- Ячейки (est: 120 min; fact: x min).

`Total:` est: 270 min; fact: x min).

#### Логика
- Сортировка по рейтингу(est: 60 min; fact: x min).
- Сортировка по имени (est: 60 min; fact: x min).
- Переход по нажатию на ячейку в профиль пользователя (est: 60 min; fact: x min).
- Наполнение ячеек данными из MockAPI (est: 120 min; fact: x min).

`Total:` est: 300 min; fact: x min.

#
## Экран UserCard (est 490; fact x).
### Module 2:

#### Верстка
- NavigationBar (est: 20 min; fact: x min).
- ImageView фото профиля (est: 30 min; fact: x min).
- NameLabel имени пользователя (est: 30 min; fact: x min).
- DescriptionLabel резюме пользователя (est: 30 min; fact x min).
- UserInfoButton кнопки сайта пользователя (est: 40 min; fact x min).
- UserCollectionButton кнопка просмотра коллекции NFT пользователя (est: 60 min; fact x min).

`Total:` est: 210 min; fact: x min).

#### Логика
- переход на сайт пользователя с помощью WebView(est: 120 min; fact: x min).
- переход на страницу коллекции NFT пользователя (est: 60 min; fact: x min).

`Total:` est: 180 min; fact: x min.

#
## Экран UserCollection (est 495; fact x).
### Module 3:

#### Верстка
- NavigationBar с заголовком (est: 35 min; fact: x min).
- Коллекцию (est: 120 min; fact: x min).
- Ячейку(est: 120 min; fact: x min).

`Total:` est: 275 min; fact: x min).

#### Логика
- Наполнение ячеек данными из MockAPI (est: 120 min; fact: x min).
- Добавление/Удаление NFT в корзину(est: 100 min; fact: x min).

`Total:` est: 220 min; fact: x min.
