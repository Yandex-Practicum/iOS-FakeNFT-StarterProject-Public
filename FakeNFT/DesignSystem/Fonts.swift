import UIKit

extension UIFont {

    static let nftFontRegularName = "SFProText-Regular"
    static let nftFontMediumName = "SFProText-Medium"
    static let nftFontBoldName = "SFProText-Bold"

    // Headline Fonts
    static let headline1 = UIFont(name: nftFontBoldName, size: 34)
    static let headline2 = UIFont(name: nftFontBoldName, size: 22)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts
    static let bodyRegular = UIFont(name: nftFontRegularName, size: 17)
    static let bodyBold = UIFont(name: nftFontBoldName, size: 17)

    // Caption Fonts
    static let caption1 = UIFont(name: nftFontRegularName, size: 15)
    static let caption2 = UIFont(name: nftFontRegularName, size: 13)
    static let caption3 = UIFont(name: nftFontMediumName, size: 10)
}
