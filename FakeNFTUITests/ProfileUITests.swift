@testable import FakeNFT
import XCTest

final class FakeNFTUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func elementsExistence() {
        XCTAssertTrue(app.staticTexts["Имя"].exists)
        XCTAssertTrue(app.staticTexts["Описание"].exists)
        XCTAssertTrue(app.staticTexts["Сайт"].exists)
        XCTAssertTrue(app.staticTexts["Мои NFT"].exists)
        XCTAssertTrue(app.staticTexts["Избранные NFT"].exists)
        XCTAssertTrue(app.staticTexts["О разработчике"].exists)
    }
    
    func testEditButton() {
        sleep(3)
        app.navigationBars.buttons.firstMatch.tap()
        print(app.buttons["changeAvatarLabel"].exists)
    }
}
