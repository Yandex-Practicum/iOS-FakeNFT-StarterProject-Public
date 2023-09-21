import XCTest

final class ImageFeedzUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

        app.launch() // запускаем приложение перед каждым тестом
    }

    func testMyNft() throws {
        // тестируем Мои НФТ
        // Подождать, пока открывается и загружается экран профиля
        // нажать на ячейку таблицы Мои НФТ
        // Сделать жест «смахивания» вверх по экрану

        // Поставить лайк в ячейке  картинки
        // Отменить лайк в ячейке  картинки
        // Нажать на экран сортиировки
        // нажать на всплывающем окне алерта кнопку сортировки по имени
        // Нажать на экран сортиировки
        // нажать на всплывающем окне алерта кнопку сортировки по цене
        // Нажать на экран сортиировки
        // нажать на всплывающем окне алерта кнопку сортировки по рейтингу
        // Вернуться на экран профиля

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

    func testАavouritesNft() throws {
        // тестируем избранные НФТ
        // Подождать, пока открывается и загружается экран профиля
        // нажать на ячейку таблицы избранные НФТ

        // Нажать лайк в ячейке  картинки
        // Вернуться на экран профиля

        let tablesQuery = app.tables
        // перейти на экран избранные нфт

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1) // берем ячейку по индексу 0
        XCTAssertTrue(cell.waitForExistence(timeout: 5))// подождёт появления ячейки на экране в течение 5 секунд.
        cell.tap()

        sleep(2)
        let cellToLike = app.collectionViews.element.cells.element(boundBy: 0)
        // нажать на кнопку лайкаа
        cellToLike.buttons["likeButtonTapped"].tap()
        sleep(2)
        app.navigationBars.buttons.element(boundBy: 0).tap()

    }

    func testProfile() throws {
        // тестируем сценарий профиля
        // Подождать, пока открывается и загружается экран профиля
        // Перейти на экран EditProfileViewController профиля
        // Проверить, что на нём отображаются ваши персональные данные
        // нажать кнопку добавить аватар
        // нажать кнопку Ок на всплывающем алерте
        // Нажать кнопку логаута
        // Проверить, что открылся экран профиля
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(3)
        XCTAssertTrue(app.images["profileImage"].exists)

        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["descriptionLabel"].exists)
        XCTAssertTrue(app.textViews["descriptionTextField"].exists)
        XCTAssertTrue(app.staticTexts["urlLabel"].exists)
        XCTAssertTrue(app.textFields["urlTextField"].exists)

        sleep(3)

        app.buttons["changeAvatarButton"].tap()
        sleep(3)
        app.buttons["showErrorAlertDoOk"].tap()
        sleep(3)

        app.buttons["closeButtonTapped"].tap()
    }

}
