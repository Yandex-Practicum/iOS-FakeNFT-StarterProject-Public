Парамонов Андрей Андреевич
<br /> Когорта: 8
<br /> Группа: 1
<br /> Эпик: Статистика
<br /> Ссылка: [link на доску](https://github.com/users/ulanoff/projects/1/views/1)

# Statistics Flow Decomposition

## Module 1:
### Экран статистики
#### Верстка

- Таблица  (est: 60 min; fact: 120 min).
- Ячейки (est: 60 min; fact: 90 min).
- Конопка фильтрации (est: 30 min; fact: 20 min).

#### Логика
- Загрузка данных (est: 120 min; fact: 90 min).
- Сортировка (est: 60 min; fact: 20 min).

`Total:` est: 330 min; fact: 340 min.

---

## Module 2:
### Экран профиля
#### Верстка
- Экран профиля (est: 120 min; fact: 120 min).

#### Логика
- Переход на экран профиля (est: 30 min; fact: 30 min).
- Загрузка информации о профиле (est: 60 min; fact: 5 min).
- Открытие webView со старницей из профиля (est: 30 min; fact: 60 min).

`Total:` est: 240 min; fact: 215 min.

---

## Module 3:
### Коллекция NFT
#### Верстка
- Таблица  (est: 60 min; fact: x min).
- Ячейки (est: 60 min; fact: x min).

#### Логика
- Переход на экран коллекции (est: 60 min; fact: x min).
- Загрузка данных (est: 60 min; fact: x min).
- Добавление в корзину (est: 60 min; fact: x min).

`Total:` est: 300 min; fact: x min.