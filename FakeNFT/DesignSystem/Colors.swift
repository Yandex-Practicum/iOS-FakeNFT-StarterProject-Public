import SwiftUI

extension Color {
    
    // MARK: - Day/Night Theme
    static let blackDay = Color("blackDay")
    static let whiteDay = Color("whiteDay")
    static let lightGrayDay = Color("lightGrayDay")
    
    // MARK: - Universal Colors
    static let yaGrayUniversal = Color(hex: "#625C5C")
    static let yaRedUniversal = Color(hex: "#F56B6C")
    static let yaBackgroundUniversal = Color(hex: "#1A1B2280")
    static let yaGreenUniversal = Color(hex: "#1C9F00")
    static let yaBlueUniversal = Color(hex: "#0A84FF")
    static let yaBlackUniversal = Color(hex: "#1A1B22")
    static let yaWhiteUniversal = Color(hex: "#FFFFFF")
    static let yaYellowUniversal = Color(hex: "#FEEF0D")
    
    // MARK: - Init with HEX
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                           (int >> 8) * 17,
                           (int >> 4 & 0xF) * 17,
                           (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                           int >> 16,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                           int >> 16 & 0xFF,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
