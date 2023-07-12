@testable import FakeNFT
import XCTest

final class ProfileViewModelTests: XCTestCase {
    func testSuccessGetProfile() {
        let stubNetworkClient = StubNetworkClient(decoder: JSONDecoder(), emulateError: false)
        let profileViewModel = ProfileViewModel(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        profileViewModel.getProfileData()
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(profileViewModel.name, "Test Profile")
        XCTAssertNil(profileViewModel.error)
    }
    
    func testFailureGetProfile() {
        let stubNetworkClient = StubNetworkClient(decoder: JSONDecoder(), emulateError: true)
        let profileViewModel = ProfileViewModel(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        profileViewModel.getProfileData()
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(profileViewModel.name)
        XCTAssertNotNil(profileViewModel.error)
    }
    
    func testSuccessPutProfile() {
        let stubNetworkClient = StubNetworkClient(decoder: JSONDecoder(), emulateError: false)
        let profileViewModel = ProfileViewModel(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        profileViewModel.putProfileData(name: "Test Profile", avatar: "", description: "", website: "", likes: [])
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(profileViewModel.name, "Test Profile")
        XCTAssertNil(profileViewModel.error)
    }
    
    func testFailurePutProfile() {
        let stubNetworkClient = StubNetworkClient(decoder: JSONDecoder(), emulateError: true)
        let profileViewModel = ProfileViewModel(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        profileViewModel.putProfileData(name: "Test Profile", avatar: "", description: "", website: "", likes: [])
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(profileViewModel.name)
        XCTAssertNotNil(profileViewModel.error)
    }
}

