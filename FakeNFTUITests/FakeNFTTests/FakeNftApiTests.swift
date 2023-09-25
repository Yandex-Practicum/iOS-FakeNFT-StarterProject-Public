@testable import FakeNFT
import XCTest
final class FakeNftApiTests: XCTestCase {
    func testUpdateProfile() {
        let netWorkClient: NetworkClient = DefaultNetworkClient()
        let api: ProfileService = ProfileService(networkClient: netWorkClient)
        let expectation = XCTestExpectation(description: "wait for result")

        let newName = UUID().uuidString
        let newDescription = UUID().uuidString
        let newWebsite = URL(string: "https://ya.ru/\(UUID().uuidString)")!
        let newAvatar = URL(string: "https://im.wampi.ru/2023/09/20/1680707244_kartinki-pibig-info-p-kot-programmist-kartinka-arti-40.png")!
        let newLikes = [Int].init(repeating: .random(in: 0...10), count: .random(in: 1...10))
        let newLikesString = newLikes.compactMap { like in
            String(like)
        }

        let uploadModel = UploadProfileModel(
            name: newName,
            description: newDescription,
            website: newWebsite,
            avatar: newAvatar,
            likes: newLikesString)
        api.updateUserProfile(with: uploadModel) { defer { expectation.fulfill() }

            guard case let .success(profile) = $0 else {
                XCTFail("Failed request")
                return
            }

            XCTAssertEqual(newName, profile.name)
            XCTAssertEqual(newDescription, profile.description)
            XCTAssertEqual(newWebsite, profile.website)
            XCTAssertEqual(newLikesString, profile.likes)
        }

        wait(for: [expectation], timeout: 1)
    }
}
