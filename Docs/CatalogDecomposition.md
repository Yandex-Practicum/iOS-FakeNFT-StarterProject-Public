Уланов Андрей Вячеславович
<br /> Когорта: 8
<br /> Группа: 1
<br /> Эпик: Каталог
<br /> Ссылка: [https://github.com/users/ulanoff/projects/1/views/1](https://github.com/users/ulanoff/projects/1/views/1)

# Catalog Flow Decomposition

## Module 1:
#### Экран каталога:
- **Верстка:**
  - Nav Bar (est: 10 min; fact: x min)
  - Коллекция (est: 60 min; fact: x min).
  - Ячейка (est: 60 min; fact: x min).
- **Логика:**
  - Загрузка данных для отображения (est: 80 min; fact: x min).
  - Сортировка (est: 60 min; fact: x min).
  - Переход на экран NFT коллекции (est: 10 min; fact: x min).

`Total:` est: 280 min; fact: x min.

## Module 2:
#### Экран NFT коллекции:
- **Верстка:**
  - Nav Bar (est: 10 min; fact: x min)
  - Превью коллекции (est: 60 min; fact: x min)
  - Описание коллекции (est: 60 min; fact: x min).
  - Коллекция (est: 60 min; fact: x min).
  - Ячейка (est: 120 min; fact: x min).
- **Логика:**
  - Переход назад (est: 10 min; fact: x min).
  - Переход на экран автора коллекции (est: 10 min; fact: x min).

`Total:` est: 330 min; fact: x min.

## Module 3:
#### Экран NFT коллекции:
- **Логика:**
  - Загрузка данных для отображения (est: 80 min; fact: x min).
  - Добавление в корзину (est: 60 min; fact: x min).
  - Добавление в избранное (est: 60 min; fact: x min).
#### Экран автора:
- **Верстка:**
  - Nav Bar (est: 10 min; fact: x min).
  - Web View (est: 30 min; fact: x min).
- **Логика:**
  - Переход назад (est: 10 min; fact: x min).

`Total:` est: 300 min; fact: x min.