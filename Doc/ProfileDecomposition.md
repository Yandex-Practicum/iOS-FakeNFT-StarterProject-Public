Плиев Георгий Знаурович
<br /> Когорта: 6
<br /> Группа: 4
<br /> Эпик: Профиль 
<br /> Ссылка на доску: https://github.com/users/artwist-polyakov/projects/1/views/1

# Profile Flow Decomposition

#1st iteration
 
## Экран Profile (est 24 hr; fact 10 hr).

#### Верстка
- Значок редактирования (est: 15 min; fact: 15 min).
- Фото пользователя (est: 30 min; fact: 20 min).
- label Имя пользователя (est: 30 min; fact: 20 min). 
- label Описание пользователя (est: 30 min; fact: 20 min). 
- label Сайт пользователя (est: 15 min; fact: 15 min).
- создание ячейки таблицы (est: 120 min ; fact: 60 min). 
- создание таблицы (est: 60 min; fact: 45 min).

`Total:` est: 300 min; fact: 195 min).

#### Логика
- Переход на экраны: редактирования, мои нфт, избранные нфт, на вебвью с сайтом пользователя (est: 60 min; fact: 40 min).
- Сетевая слой для работы с получением данных профиля (est: 180 min; fact: 200 min).

`Total:` est: 240 min; fact: 240 min.

#2nd Iteration

## Экран Profile Editing (est 48 hr; fact 12 hr).

#### Верстка
- imageView с крестиком (est: 15 min; fact: 10 min).
- аватар пользователя (est: 30 min; fact: 20 min).
- label загрузить изображение (est: 30 min; fact: 15 min).
- label плюс textfield с именем пользователя (est: 30 min; fact: 30 min).
- label плюс textfield с описанием (est: 30 min; fact: 15 min).
- label плюс textfield с гиперссылкой (est: 30 min; fact: 15 min).

`Total:` est: 165 min; fact: 105 min).

## Экран My NFT (est 72 hr; fact 32 hr).

#### Верстка
- верстка навбара (est: 60 min; fact: 10 min).
- ячейка таблицы (est: 60 min; fact: 45 min).
- создание tableview (est: 60 min; fact: 40 min).
- создание алерта типа actionsheet (est: 15 min; fact: 20 min).
- label "у вас еще нет нфт" (est: 15 min; fact: 10 min).

`Total:` est: 210 min; fact: 125 min.

#### Логика
- Скрытие/показ лейбла/таблицы и элементов навбара в зависимости от наличия нфт у пользователя (est: 30 min; fact: 30 min).
- Сортировка (est: 60 min; fact: 60 min).
- Сохранить способ сортировки (est: 60 min; fact: 20 min).
- Логика сетевого слоя для загрузки нфт пользователя (est: 120 min; fact: 60 min).
- Индикатор загрузки (est: 30 min; fact: 20 min).

`Total:` est: 270 min; fact: 190 min.

# 3rd Iteration

## Экран Избранные NFT (est 72 hr; fact x).

#### Верстка
- верстка навбара (est: 60 min; fact: x min).
- ячейка таблицы (est: 60 min; fact: x min).
- создание сcollectionView (est: 120 min; fact: x min).
- label "у вас еще нет избранных нфт" (est: 15 min; fact: x min).

`Total:` est: 255 min; fact: x min.

#### Логика
- Скрытие/показ лейбла/коллекции и элементов навбара в зависимости от наличия избранных нфт у пользователя (est: 30 min; fact: x min).
- Логика сетевого слоя для загрузки избранных нфт пользователя (est: 120 min; fact: x min).
- Логика сетевого слоя для удаления нфт из избранных (est: 120 min; fact: x min).
- Индикатор загрузки (est: 30 min; fact: x min).

`Total:` est: 300 min; fact: x min.
