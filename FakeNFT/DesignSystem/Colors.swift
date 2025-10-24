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
    
    // MARK: - Theme Colors (Day/Night)
    
    static let black = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? UIColor(hexString: "FFFFFF") // White [night]
        : UIColor(hexString: "1A1B22") // Black [day]
    }
    
    static let white = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? UIColor(hexString: "1A1B22") // White [night]
        : UIColor(hexString: "FFFFFF") // White [day]
    }
    
    static let lightGray = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? UIColor(hexString: "2C2C2E") // Light grey [night]
        : UIColor(hexString: "F7F7F8") // Light grey [day]
    }
    
    // MARK: - Universal Colors
    
    static let greyUniversal = UIColor(hexString: "625C5C")
    static let redUniversal = UIColor(hexString: "F56B6C")
    static let greenUniversal = UIColor(hexString: "1C9F00")
    static let blueUniversal = UIColor(hexString: "0A84FF")
    static let yellowUniversal = UIColor(hexString: "FEEF0D")
    
    // Background Universal with 50% opacity
    static let backgroundUniversal: UIColor = {
        return UIColor(hexString: "1A1B22").withAlphaComponent(0.5)
    }()
    
    // MARK: - Component Colors (для конкретных компонентов UI)
    
    static let segmentActive = black
    static let segmentInactive = lightGray
    static let closeButton = black
}
