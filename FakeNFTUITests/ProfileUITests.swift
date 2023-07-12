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
    
    func testElementsExistence() {
        XCTAssertTrue(app.images["avatarImage"].exists)
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["descriptionLabel"].exists)
        XCTAssertTrue(app.buttons["websiteLabel"].exists)
        XCTAssertTrue(app.tables["profileAssetsTable"].exists)
        XCTAssertTrue(app.staticTexts["Мои NFT"].exists)
        XCTAssertTrue(app.staticTexts["Избранные NFT"].exists)
        XCTAssertTrue(app.staticTexts["О разработчике"].exists)
    }
    
    func testEditButtonTap() {
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.buttons["changeAvatarLabel"].exists)
    }
    
    func testWebsiteLinkTap() {
        app.buttons["websiteLabel"].tap()
        XCTAssertTrue(app.webViews.firstMatch.exists)
    }
    
    func testMyNFTsTap() {
        app.tables["profileAssetsTable"].staticTexts["Мои NFT"].tap()
        XCTAssertEqual(app.navigationBars.staticTexts.firstMatch.label, "Мои NFT")
    }
    
    func testFavoriteNFTsTap() {
        app.tables["profileAssetsTable"].staticTexts["Избранные NFT"].tap()
        XCTAssertEqual(app.navigationBars.staticTexts.firstMatch.label, "Избранные NFT")
    }
    
    func testDeveloperTap() {
        app.tables["profileAssetsTable"].staticTexts["О разработчике"].tap()
        XCTAssertTrue(app.webViews.firstMatch.exists)
    }
    
    //Если делать тесты по одному, API падает с 429 статусом
    func testAllTogether() {
        testElementsExistence()
        testEditButtonTap()
        app.buttons["closeButton"].tap()
        testWebsiteLinkTap()
        app.swipeDown(velocity: .fast)
        testMyNFTsTap()
        app.buttons["backButton"].tap()
        testFavoriteNFTsTap()
        app.buttons["backButton"].tap()
        testDeveloperTap()
        app.buttons["backButton"].tap()
    }
}
