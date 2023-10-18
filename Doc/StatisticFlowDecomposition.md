Пичугин Александр Дмитриевич
<br /> Когорта: 6
<br /> Группа: 4
<br /> Эпик: Статистика 
<br /> Ссылка на доску: https://github.com/users/artwist-polyakov/projects/1/views/1

# Statistic Flow Decomposition


## Экран Statistics (est 10 hr; fact x).

#### Верстка
- создание кнопки сортировки (est: 15 min; fact: x min).
- создание ячейки таблицы (est: 120 min ; fact: x min). 
- создание таблицы (est: 60 min; fact: x min).
- создание окна выбора типа фильтрации (est: 15 min; fact: x min).

`Total:` est: 210 min; fact: x min.

#### Логика
- переход на экран User Cart (est: 15 min; fact: x min).
- логика сетевого слоя для загрузки в таблицу аватарки, имени пользователя, кол-ва NFT (est: 180 min; fact: x min).
- индикатор загрузки (est: 30 min; fact: x min).
- сортировка (est: 60 min; fact: x min).
- сохранить способ сортировки (est: 60 min; fact: x min).

`Total:` est: 345 min; fact: x min.

## Экран User Card (est 5 hr; fact x).

#### Верстка

 - фото пользователя (est: 15 min; fact: x min).
 - имя пользователя (est: 15 min; fact: x min).
 - описание пользователя (est: 15 min; fact: x min).
 - кнопка "Перейти на сайт пользователя" (est: 15 min; fact: x min).
 - кнопка коллекция NFT (est: 15 min; fact: x min).

`Total:` est: 75 min; fact: x min).

#### Логика
- переход на сайт пользователя c созданием WebView (est: 180 min; fact: x min).
- переход на экран Users Collection (est: 15 min; fact: x min).

`Total:` est: 195 min; fact: x min.


## Экран Users Collection (est 11 hr; fact x).

#### Верстка
- верстка навбара (est: 15 min; fact: x min).
- верстка ячейчки UICollectionView с иконкой, сердечком, названием, рейтингом из 0-5 звезд, стоимостью NFT (в ETH), кнопкой добавления/удаления NFT из корзины.(est: 210 min; fact: x min).
- создание  UICollectionView(est: 60 min; fact: x min).

`Total:` est: 285 min; fact: x min.

#### Логика

- логика сетевого слоя для загрузки данных для UICollectionView (est: 180 min; fact: x min).
- логика сетевого слоя для удаления/добавления NFT из корзины (est: 180 min; fact: x min).
- индикатор загрузки (est: 30 min; fact: x min).


`Total:` est: 360 min; fact: x min.
