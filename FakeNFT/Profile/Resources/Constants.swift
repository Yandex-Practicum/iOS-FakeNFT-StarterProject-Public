//
//  Constants.swift
//  FakeNFT
//

import Foundation

enum Constants {

    // URL strings
    static let avatarImageURLString = "https://raw.githubusercontent.com/DemidenGo/my-resume/56bfca5ea539e1da0903de747043119ed4d02b20/img/demidenko-yurii.jpg"
    static let endpointURLString = "https://64611c69491f9402f49ecce1.mockapi.io/api/v1/"
    static let profilePathComponentString = "profile/1"

    // Localized text strings
    static func localizedStringFor(tableViewCell: Int, myNFT: Int = 0, favoritesNFT: Int = 0) -> String {
        switch tableViewCell {
        case 0:
            let localizedFormatString = NSLocalizedString("myNFTs", comment: "Label text for the first table row")
            return String(format: localizedFormatString, myNFT)
        case 1:
            let localizedFormatString = NSLocalizedString("favoritesNFTs", comment: "Label text for the second table row")
            return String(format: localizedFormatString, favoritesNFT)
        default:
            return NSLocalizedString("aboutDeveloper", comment: "Label text for the third table row")
        }
    }
}
