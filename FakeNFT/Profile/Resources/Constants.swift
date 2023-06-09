//
//  Constants.swift
//  FakeNFT
//

import Foundation

enum Constants {

    // URL strings
    static let mockAvatarImageURLString = "https://raw.githubusercontent.com/DemidenGo/my-resume/56bfca5ea539e1da0903de747043119ed4d02b20/img/demidenko-yurii.jpg"
    static let endpointURLString = "https://64611c69491f9402f49ecce1.mockapi.io/api/v1/"
    static let profilePathComponentString = "profile/1"
    static let nftPathComponentString = "nft/%d"
    static let stubUserWebsiteURLString = "https://github.com/demidengo"

    // Mock strings
    static let mockAuthorString = "John Doe"
    static let mockCurrencyString = " ETH"

    // Avatar placeholder file name
    static let avatarPlaceholder = "AvatarPlaceholder"

    // Buttons and labels constant strings
    static let changeAvatarButtonTitle = NSLocalizedString("changePhoto", comment: "Change avatar button label text")
    static let nameLabelText = NSLocalizedString("name", comment: "User name label")
    static let descriptionLabelText = NSLocalizedString("description", comment: "User description label")
    static let websiteLabelText = NSLocalizedString("website", comment: "User website label")
    static let loadNewAvatarButtonTitle = NSLocalizedString("uploadImage", comment: "Upload new avatar label")
    static let sortingAlertTitle = NSLocalizedString("sorting", comment: "Sorting alert title")
    static let sortByPriceString = NSLocalizedString("sortByPrice", comment: "Sort by price button text")
    static let sortByRatingString = NSLocalizedString("sortByRating", comment: "Sort by rating button text")
    static let sortByNameString = NSLocalizedString("sortByName", comment: "Sort by name button text")
    static let closeButtonTitle = NSLocalizedString("closeTitle", comment: "Close button title text")
    static let myNFTStubLabelText = NSLocalizedString("myNFTStub", comment: "My NFTs stub label text")
    static let favoritesNFTStubLabelText = NSLocalizedString("favoritesNFTStub", comment: "Favorites NFTs stub label text")
}
