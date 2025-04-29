@testable import FakeNFT
import XCTest

final class StatisticUsersListTests: XCTestCase {

    func testStatisticLoadingView() {
        let statisticUsersListVCSpy = StatisticUsersListViewControllerSpy()
        
        statisticUsersListVCSpy.loadView()
        
        XCTAssertTrue(statisticUsersListVCSpy.view == statisticUsersListVCSpy.statisticUsersListView)
    }
    
    func testClickSortButtonTap() {
        let statisticUsersListViewControllerSpy = StatisticUsersListViewControllerSpy()
        
        _ = statisticUsersListViewControllerSpy.view
        statisticUsersListViewControllerSpy.statisticUsersListView.statisticUsersListViewDelegate?.clickSortButton()
        
        XCTAssertTrue(statisticUsersListViewControllerSpy.sortButtonClicked)
    }
    
    func testViewConfiguration() {
        let statisticUsersListViewControllerSpy = StatisticUsersListViewControllerSpy()
        
        _ = statisticUsersListViewControllerSpy.view
        
        XCTAssertTrue(statisticUsersListViewControllerSpy.view.backgroundColor == .background)
    }
}

final class StatisticUsersListViewControllerSpy: UIViewController & StatisticUsersListViewDelegate {
    let statisticUsersListView = StatisticUsersListView()
    var sortButtonClicked = false
    
    override func loadView() {
        self.view = statisticUsersListView
    }
    override func viewDidLoad() {
        statisticUsersListView.configure()
        statisticUsersListView.statisticUsersListViewDelegate = self
    }
    
    func clickSortButton() {
        sortButtonClicked = true
    }
}

final class UserCardTests: XCTestCase {
    let sut = StatisticUsersListViewController()
    
    func testUserCardLoadingView() {
        let userCardViewControllerSpy = UserCardViewControllerSpy(statisticUsersListViewController: sut)
        
        userCardViewControllerSpy.loadView()
        
        XCTAssertTrue(userCardViewControllerSpy.view == userCardViewControllerSpy.userCardView)
    }
    
    func testUserWebsiteOpen() {
        let userCardViewControllerSpy = UserCardViewControllerSpy(statisticUsersListViewController: sut)
        
        _ = userCardViewControllerSpy.view
        userCardViewControllerSpy.userCardView.openUserWebsiteDelegate?.openUserWebsite()
        
        XCTAssertTrue(userCardViewControllerSpy.websiteIsOpen)
    }
    
    func testUserCardConfiguration() {
        let userCardViewControllerSpy = UserCardViewControllerSpy(statisticUsersListViewController: sut)
        
        _ = userCardViewControllerSpy.view
        
        XCTAssertTrue(userCardViewControllerSpy.view.backgroundColor == .background)
    }
    
    func testUpdateProfile() {
        let userCardViewControllerSpy = UserCardViewControllerSpy(statisticUsersListViewController: sut)
        let testUser = UsersListModel(name: "testUser", avatar: "", description: "", website: "", nfts: [], rating: "", id: "")
        
        sut.statisticUsersListVCDelegate?.didTapCell(with: testUser)
        
        XCTAssertTrue(userCardViewControllerSpy.cellTapped)
    }
}

final class UserCardViewControllerSpy: UIViewController & OpenUserWebsiteDelegate & StatisticUsersListVCDelegate {
    let sut: StatisticUsersListViewController
    let userCardView = UserCardView()
    var websiteIsOpen = false
    var cellTapped = false
    
    init(statisticUsersListViewController: StatisticUsersListViewController) {
        self.sut = statisticUsersListViewController
        super.init(nibName: nil, bundle: nil)
        statisticUsersListViewController.statisticUsersListVCDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = userCardView
    }
    override func viewDidLoad() {
        userCardView.configure()
        userCardView.openUserWebsiteDelegate = self
    }
    
    func didTapCell(with user: FakeNFT.UsersListModel) {
        cellTapped = true
    }
    
    func openUserWebsite() {
        websiteIsOpen = true
    }
}

final class WebViewTests: XCTestCase {
    func testWebViewLoadingView() {
        let webViewViewControllerSpy = WebViewViewControllerSpy()
        
        webViewViewControllerSpy.loadView()
        
        XCTAssertTrue(webViewViewControllerSpy.view == webViewViewControllerSpy.webViewView)
    }
    
    func testWebViewViewConfiguration() {
        let webViewViewControllerSpy = WebViewViewControllerSpy()
        
        _ = webViewViewControllerSpy.view
        
        XCTAssertTrue(webViewViewControllerSpy.view.backgroundColor == .background)
    }
    
    func testShowProgressView() {
        let webViewView = WebViewView()
        
        webViewView.progressView.progress = 0.5
        
        XCTAssertFalse(webViewView.progressView.isHidden)
    }
}

final class WebViewViewControllerSpy: UIViewController {
    let webViewView = WebViewView()
    
    override func loadView() {
        self.view = webViewView
    }
    
    override func viewDidLoad() {
        webViewView.configure()
    }
}
