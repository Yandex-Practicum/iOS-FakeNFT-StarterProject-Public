import XCTest

final class ImageFeedzUITests: XCTestCase {

    private let app = XCUIApplication() // Переменная приложения

    override func setUpWithError() throws {
        continueAfterFailure = false // Настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

        app.launch() // запускаем приложение перед каждым тестом
    }

    func testMyNft() throws {
         /* Тестируем Мои НФТ
         Подождать, пока открывается и загружается экран профиля
         нажать на ячейку таблицы Мои НФТ
         Сделать жест «смахивания» вверх по экрану
        
         Поставить лайк в ячейке  картинки
         Отменить лайк в ячейке  картинки
         Нажать на экран сортиировки
         нажать на всплывающем окне алерта кнопку сортировки по имени
         Нажать на экран сортиировки
         нажать на всплывающем окне алерта кнопку сортировки по цене
         Нажать на экран сортиировки
         нажать на всплывающем окне алерта кнопку сортировки по рейтингу
         Вернуться на экран профиля
          */

        let tablesQuery = app.tables
        // перейти на экран мио нфт

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) // берем ячейку по индексу 0
        XCTAssertTrue(cell.waitForExistence(timeout: 5))// подождёт появления ячейки на экране в течение 5 секунд.
        cell.tap()
        cell.swipeUp() // Сделать жест «смахивания» вверх по экрану

        sleep(2)

        let cellToLike = tablesQuery.children(
            matching: .cell
        ).element(boundBy: 1) // выбираем верхнюю первую ячейку=картинку

        // нажать на кнопку лайкаа
        cellToLike.buttons["likeButtonTapped"].tap()
        sleep(2)
        cellToLike.buttons["likeButtonTapped"].tap()

        sleep(3)
        // нажать на экран сортировки
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        // нажать на кнопку сортировки по имени
        app.buttons["nameSorting"].tap()
        sleep(3)
        // нажать на экран сортировки
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(3)
        // нажать на кнопку сортировки по цене
        app.buttons["priceSorting"].tap()
        sleep(3)
        // нажать на экран сортировки
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(3)
        // нажать на кнопку сортировки по рейтингу
        app.buttons["ratingSorting"].tap()
        sleep(3)
        app.navigationBars.buttons.element(boundBy: 0).tap()

    }

    func testFavouritesNft() throws {
       /* Тестируем избранные НФТ
         Подождать, пока открывается и загружается экран профиля
         нажать на ячейку таблицы избранные НФТ
         Нажать лайк в ячейке  картинки
         Вернуться на экран профиля
        */

        let tablesQuery = app.tables
        // Перейти на экран избранные нфт
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1) // Берем ячейку по индексу 1
        XCTAssertTrue(cell.waitForExistence(timeout: 5))// Подождёт появления ячейки на экране в течение 5 секунд.
        cell.tap()
        sleep(2)
        let cellToLike = app.collectionViews.element.cells.element(boundBy: 0)
        // Нажать на кнопку лайка
        cellToLike.buttons["likeButtonTapped"].tap()
        sleep(2)
        app.navigationBars.buttons.element(boundBy: 0).tap()

    }

    func testProfile() throws {
        /* Тестируем сценарий профиля
         Подождать, пока открывается и загружается экран профиля
         Перейти на экран EditProfileViewController профиля
         Проверить, что на нём отображаются ваши персональные данные
         Нажать кнопку добавить аватар
         Нажать кнопку Ок на всплывающем алерте
         Нажать кнопку логаута
         Проверить, что открылся экран профиля
         */
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(3)

        // Ввод текста в поле nameTextField
        let nameTextField = app.textFields["nameTextField"]
        nameTextField.tap()
        nameTextField.press(forDuration: 2)
        app.menuItems["Select All"].tap()
        nameTextField.typeText("Студентус практикус")

        // Подождите 2 секунды
        sleep(2)
        // Ввод текста в поле описание
        let descriptionTextField = app.textViews["descriptionTextField"]
        descriptionTextField.tap()
        app.menuItems["Select All"].tap()
        descriptionTextField.typeText("Прошел 5-й спринт, и этот пройду")

        // Ввод текста в поле ЮРЛ
        let urlTextField = app.textFields["urlTextField"]
        urlTextField.tap()
        urlTextField.doubleTap()
        urlTextField.press(forDuration: 3)
        urlTextField.typeText("https://practicum.yandex.ru/ios-developer")

        // Нажимаем на кнопку сменить аватар
        app.buttons["changeAvatarButton"].tap()
        sleep(3)

        // Вводим тестовый аватар
        let alertTextfield = app.alerts.textFields.element
        alertTextfield.tap()
        sleep(3)
        alertTextfield.typeText("https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG")
        sleep(3)
        // Нажимаем Ок кнопки алерта

        app.buttons["showErrorAlertDoOk"].tap()
        sleep(3)

        // Проверка существования всех полей
        XCTAssertTrue(app.images["profileImage"].exists)
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["descriptionLabel"].exists)
        XCTAssertTrue(app.textViews["descriptionTextField"].exists)
        XCTAssertTrue(app.staticTexts["urlLabel"].exists)
        XCTAssertTrue(app.textFields["urlTextField"].exists)
        sleep(3)

        // Нажатие на кнопку закрытия окна редактирования профиля
        app.buttons["closeButtonTapped"].tap()
    }

    func testAboutDevelopers() throws {
        /* Тестируем экран О разработчиках
         Проверить, что открылся экран профиля
         Проверить наличие всех заполненных полей
         Вернуться на экран профиля
         */

        let tablesQuery = app.tables
        // Перейти на экран избранные о разработчиках
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 2) // Берем первую ячейку
        XCTAssertTrue(cell.waitForExistence(timeout: 5))// Подождёт появления ячейки на экране в течение 5 секунд.

        cell.tap()
        sleep(2)
        cell.swipeUp() // Сделать жест «смахивания» вверх по экрану

        // Проверка существования всех полей
        XCTAssertTrue(app.images["devsImageView"].exists)
        XCTAssertTrue(app.staticTexts["devsNameLabel"].exists)
        XCTAssertTrue(app.staticTexts["devsDescriptionLabel"].exists)
        XCTAssertTrue(app.staticTexts["emailLabel"].exists)
        XCTAssertTrue(app.staticTexts["telegramLabel"].exists)

        sleep(3)

        // Нажатие на кнопку закрытия окна 
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
