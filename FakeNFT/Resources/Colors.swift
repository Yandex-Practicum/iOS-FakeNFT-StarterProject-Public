import UIKit

extension UIColor {
    // MARK: - Public properties
    static let ypLightGrayDay = UIColor(hex: 0xF7F7F8)
    static let ypLightGrayNight = UIColor(hex: 0x2C2C2E)

    static let ypGrayUniversal = UIColor(hex: 0x625C5C)
    static let ypRedUniversal = UIColor(hex: 0xF56B6C)
    static let ypBackgroundUniversal = UIColor(hex: 0x1A1B22, alpha: 0.5)
    static let ypGreenUniversal = UIColor(hex: 0x1C9F00)
    static let ypBlueUniversal = UIColor(hex: 0x0A84FF)
    static let ypBlackUniversal = UIColor(hex: 0x1A1B22)
    static let ypWhiteUniversal = UIColor(hex: 0xFFFFFF)
    static let ypYellowUniversal = UIColor(hex: 0xFEEF0D)

    // MARK: - Life cicle
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UIColor {
    static var ypBlack: UIColor {
        UIColor { traits -> UIColor in
            return traits.userInterfaceStyle == .dark ? .ypWhiteUniversal : .ypBlackUniversal
        }
    }

    static var ypWhite: UIColor {
        UIColor { traits -> UIColor in
            return traits.userInterfaceStyle == .dark ? .ypBlackUniversal : .ypWhiteUniversal
        }
    }

    static var ypLightGray: UIColor {
        UIColor { traits -> UIColor in
            return traits.userInterfaceStyle == .dark ? .ypLightGrayNight : .ypLightGrayDay
        }
    }
}
