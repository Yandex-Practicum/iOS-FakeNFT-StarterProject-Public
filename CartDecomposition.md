Халилулин Руслан Батырович
<br /> Когорта: 10
<br /> Группа: 4
<br /> Эпик: Корзина
<br /> Ссылка: https://github.com/users/s4fonovoleg/projects/1

# Cart Flow Decomposition


## Module 1:
### Главный экран корзины
#### Верстка
- NavigationBar (est: 30 min: fact: x min).
- TableViewCell (est: 60 min; fact: x min).
- TableView (est: 120 min; fact: x min).
- Кнопка оплаты и стоимости (est: 60 min; fact: x min).

#### Логика
- Конфигурация ячейки (est: 120 min; fact: x min).
- Обновление стоимости nft (est: 120 min; fact: x min).
- Сортировка (est: 120 min; fact: x min).
- Сохранить способ сортировки (est: 60 min; fact: x min).

### Экран Удаления nft
#### Верстка
- Блюр фона контроллера (est: 60 min; fact: x min).
- UI(иконка, текс и кнопки) (est: 60 min; fact: x min).

#### Логика
- Удаление nft (est: 60 min; fact: x min).
- Возврат на жкран корзины (est: 30 min; fact: x min).

`Total:` est: 780 min; fact: x min.


## Module 2:
### Экран выбора оплаты
#### Верстка
- NavigationBar (est: 60 min; fact: x min).
- CollectionViewCell (est: 120 min; fact: x min).
- Кнопка оплаты (est: 60 min; fact: x min).
- View пользовательского соглашения (est: 30 min; fact: x min).

#### Логика
- Переход на экран с выбором валюты (est: 60 min; fact: x min).
- Индикатор загрузки (est: 30 min; fact: x min).
- Выбор ячейки валюты (est: 30 min; fact: x min).
- Переход обратно на экран корзины (est: 60 min; fact: x min).


`Total:` est: 450 min; fact: x min.

## Module 3:
### Экран успешной оплаты
#### Верстка
- Изображение nft (est: 60 min: fact: x min).
- Текст под nft (est: 30 min; fact: x min).
- Кнопка возврата (est: 60 min; fact: x min).
- Alert неудачной оплаты (est: 60 min; fact: x min).
- Зашлушка пустой корзиный (est: 30 min; fact: x min).

#### Логика
- Получение изображения нужной nft (est: 60 min; fact: x min).
- Реализация возврата на прошлый экран( est: 60 min; fact: x min).
- Повторная оплата запрос на сервер (est: 60 min; fact: x min).
- Скрытие отображение заглушки корзины (est: 60 min; fact: x min).


`Total:` est: 480 min; fact: x min.
