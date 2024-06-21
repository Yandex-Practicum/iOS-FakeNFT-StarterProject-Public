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
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // MARK: - Yandex Monochrome Colors

    static var ypBlackDay: UIColor { UIColor(named: "ypBlackDay") ?? UIColor.black }
    static var ypLightGrayDay: UIColor { UIColor(named: "ypLightGrayDay") ?? UIColor.lightGray }
    static var ypWhiteDay: UIColor { UIColor(named: "ypWhiteDay") ?? UIColor.white }

    // MARK: - Yandex Universal Colors

    static var ypBackground: UIColor { UIColor(named: "ypBackground") ?? UIColor.lightGray }
    static var ypBlack: UIColor { UIColor(named: "ypBlack") ?? UIColor.black }
    static var ypBlue: UIColor { UIColor(named: "ypBlue") ?? UIColor.systemBlue}
    static var ypGray: UIColor { UIColor(named: "ypGray") ?? UIColor.systemGray }
    static var ypGreen: UIColor { UIColor(named: "ypGreen") ?? UIColor.systemGreen }
    static var ypRed: UIColor { UIColor(named: "ypRed") ?? UIColor.systemRed }
    static var ypWhite: UIColor { UIColor(named: "ypWhite") ?? UIColor.white }
    static var ypYellow: UIColor { UIColor(named: "ypYellow") ?? UIColor.yellow }
}
