Алексей Тиньков
<br /> Кагорта: 6
<br /> Группа: 5
<br /> Эпик: Каталог

# Catalog Flow Decomposition

## Экран Catalogue (est: 390 min; fact: x min).

### Верстка
- навигационный бар и кнопка сортировки (est: 20 min; fact: x min).
- коллекция (est: 30 min; fact: x min).
- ячейки коллекции: картинка, название, количество NFT (est: 60 min; fact: x min).
- алерт сортировки (est: 30 min; fact: x min).

`Total:` est: 140 min; fact: x min).

### Логика
- загрузка каталога, индикатор загрузки (est: 180 min; fact: x min).
- сортировка (est: 30 min; fact: x min).
- сохранение порядка сортировки (est: 30 min; fact: x min).
- переход на экран коллекции (est: 10 min; fact: x min).

`Total:` est: 250 min; fact: x min).

## Экран Collection (est: 590 min; fact: x min).

### Верстка
- обложка (est: 20 min; fact: x min).
- кнопка возврата на предыдущий экран (est: 20 min; fact: x min).
- название (est: 20 min; fact: x min).
- автор (est: 20 min; fact: x min).
- описание (est: 20 min; fact: x min).
- колекция (est: 30 min; fact: x min).
- ячейки коллкции: картинка, лайк, рейтинг, название, цена, корзина (est: 120 min; fact: x min).

`Total:` est: 250 min; fact: x min).

### Логика
- загрузка коллекции, индикатор загрузки (est: 180 min; fact: x min).
- возврат к экрану каталога (est: 20 min; fact: x min).
- переход на страницу автора (est: 20 min; fact: x min).
- лайк (est: 60 min; fact: x min).
- корзина (est: 60 min; fact: x min).

`Total:` est: 340 min; fact: x min).

# Дополнительные задачи, пересекающиеся с другими эпиками
- лаунчскрин
- определить цвета в ассетах
- верстка таббара кодом
- класс для работы с API

	
