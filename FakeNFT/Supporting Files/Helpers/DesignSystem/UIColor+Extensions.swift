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
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }
    
    static var appBlack: UIColor { UIColor(named: "AppBlack") ?? .red }
    static var appBlackOnly: UIColor { UIColor(named: "AppBlackOnly") ?? .red }
    static var appBlue: UIColor { UIColor(named: "AppBlue") ?? .red }
    static var appGray: UIColor { UIColor(named: "AppGray") ?? .red }
    static var appLightGray: UIColor { UIColor(named: "AppLightGray") ?? .red}
    static var appRed: UIColor { UIColor(named: "AppRed") ?? .red }
    static var appWhite: UIColor { UIColor(named: "AppWhite") ?? .red }
    static var yellowUniversal: UIColor { UIColor(named: "YellowUniversal") ?? .red }
    static var lightGrey: UIColor { UIColor(named: "LightGray") ?? .red }
    static var appWhiteOnly: UIColor { UIColor(named: "AppWhiteOnly") ?? .red }
}
