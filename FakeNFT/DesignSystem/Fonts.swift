import UIKit

extension UIFont {

    static let nftFontRegularName = "SFProText-Regular"
    static let nftFontMediumName = "SFProText-Medium"
    static let nftFontBoldName = "SFProText-Bold"

    // Headline Fonts
    static var headline1 = UIFont(name: nftFontBoldName, size: 34)
    static var headline2 = UIFont(name: nftFontBoldName, size: 22)

    // Body Fonts
    static var bodyRegular = UIFont(name: nftFontRegularName, size: 17)
    static var bodyBold = UIFont(name: nftFontBoldName, size: 17)

    // Caption Fonts
    static var caption1 = UIFont(name: nftFontRegularName, size: 15)
    static var caption2 = UIFont(name: nftFontRegularName, size: 13)
    static var caption3 = UIFont(name: nftFontMediumName, size: 10)
}
