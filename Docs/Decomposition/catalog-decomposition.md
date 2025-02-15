# Дипломный проект FakeNFT. Декомпозиция

Торопов Александр Вадимович
Когорта: 22
Группа: 3
Эпик: Каталог
ссылка: https://github.com/users/gibbonch/projects/1/views/1

## Epic 1/3 (Экран "Catalog")
1.  Создание модели Catalog
    est: 10 min, fact: X min
2.  Создание модели запроса CatalogRequest
    est: 10 min, fact: X min
3.  Разработка протокола CatalogService
    est: 30 min, fact: X min
4.  Написание слоя ViewModel 
    est: 1 h 30 min, fact: X min
5.  Разаработка модели ячейки и верстка ячейки
    est: 45 min, fact: X min
6.  Верстка экрана (UITableView)
    est: 2 h, fact: X min
7.  Разработка ImplCatalogService (будет делать запросы на сервер)
    est: 2 h 30 min, fact: X min
8.  Внедрение пагинации 
    est: 1 h, fact: X min
9.  Внедрение логики сортировки во view model
    est: 40 min, fact: X min
9.  Добавление на View алерта фильтрации
    est: 15 min, fact: X min
10. Рефакторинг 
    est: 4 h, fact: X min

## Epic 2/3 (Экран "NftCollection" + Stub web view)
1.  Разработка сущности CartModel (необходима для передачи данных на экран корзины)
    est: 1 h 45 min, fact: X min
2.  Написание модели запроса для добавления в избранное
    est: 15 min, fact: X min
3.  Разработка сервиса FavouritesService
    est: 1 h 15 min, fact: X min
4.  Рефакторинг модели NFT и NFTService
    est: 1 h, fact: X min
5.  Рзработка слоя ViewModel для экрана (NftCollection)
    est: 1 h, fact: X min
6.  Написание RaitingView
    est: 40 min, fact: X min
7.  Верстка ячейки NftCell
    est: 50 min, fact: X min
8.  Верстка экрана. Можно попробовать все сделать коллекцией (UICollectionViewCompositionalLayout)
    est: 2 h, fact: X min
9.  Создание экрана заглушки для линков (WevView)
    est: 1 h 30 min, fact: X min
10. Рефакторинг 
    est: 4 h, fact: X min

## Epic 3/3 (Экран "NftDetail" + NftSlider)
1.  Создание NftSliderView (стоит сделать переиспользуемой, потому что она на двух экранах)
    est: 2 h 30 min, fact: X min
2.  Создание Модели валюты
    est: 1 h 45 min, fact: X min
3.  Написание CurrencyService для запроса валют
    est: 1 h 45 min, fact: X min
4.  Разработка ViewModel для экрана
    est: 1 h 10 min, fact: X min
5.  Написание CurrencyCell
    est: 30 min, fact: X min
6.  Верстка экрана (думаю также использовать UICollectionViewCompositionalLayout, но не уверен получится ли сделать секцию валют по дизайну)
    est: 4 h 30 min, fact: X min
7.  Рефакторинг 3 эпика
    est: 4 h, fact: X min
8.  Рефакторинг сетевого взаимодействия
    est: 2 h, fact: X min
9.  Добавление кэширования 
    est: 4 h, fact: X min
