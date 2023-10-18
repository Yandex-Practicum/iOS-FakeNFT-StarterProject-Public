import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }

    // Colors with dark mode
    static let ypBlackWithDarkMode = UIColor(named: "blackWithDarkMode") ?? UIColor.black
    static let ypWhiteWithDarkMode = UIColor(named: "whiteWithDarkMode") ?? UIColor.white
    static let ypLightGreyWithDarkMode = UIColor(named: "lightGreyWithDarkMode") ?? UIColor.lightGray

    // Universal colors
    static let ypGrayUniversal = UIColor(named: "greyUniversal") ?? UIColor.gray
    static let ypRed = UIColor(named: "redUniversal") ?? UIColor.red
    static let ypGreen = UIColor(named: "green") ?? UIColor.green
    static let ypBackground = UIColor(named: "background") ?? UIColor.systemBackground
    static let ypBlue = UIColor(named: "blue") ?? UIColor.blue
    static let ypBlackUniversal = UIColor(named: "blackUniversal") ?? UIColor.blue
    static let ypWhiteUniversal = UIColor(named: "whiteUniversal") ?? UIColor.white
    static let ypYellow = UIColor(named: "yellow") ?? UIColor.yellow
}
