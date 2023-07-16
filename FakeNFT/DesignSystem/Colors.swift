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

    // Ниже приведены примеры цветов, настоящие цвета надо взять из фигмы
    
    // Adapting Colors
    static var ypBlack: UIColor? { UIColor(named: "ypBlack") }
    static var ypWhite: UIColor? { UIColor(named: "ypWhite") }
    static var ypLightGrey: UIColor? { UIColor(named: "ypLightGrey") }

    // Primary Colors
    static let primary = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
    static let universalBlue = UIColor(red: 10 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1)
    static let universalYellow = UIColor(red: 254 / 255, green: 239 / 255, blue: 13 / 255, alpha: 1)
    static let universalGreen = UIColor(red: 28 / 255, green: 159 / 255, blue: 0 / 255, alpha: 1)
    static let universalGray = UIColor(red: 98 / 255, green: 92 / 255, blue: 92 / 255, alpha: 1)
    static let universalRed = UIColor(red: 245 / 255, green: 107 / 255, blue: 108 / 255, alpha: 1)
    static let universalBlack = UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 1)
    static let universalWhite = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    
    // Secondary Colors
    static let secondary = UIColor(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 1.0)

    // Background Colors
    static let background = UIColor.white
    static let universalBackground = UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.5)

    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black
}
