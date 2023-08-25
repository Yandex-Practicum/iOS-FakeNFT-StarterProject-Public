import UIKit

extension UIFont {
    enum Medium {
        static let size10 = UIFont(name: "SFProText-Medium", size: 10) ??
        UIFont.systemFont(ofSize: 10, weight: .medium)
    }

    enum Regular {
        static let size13 = UIFont(name: "SFProText-Regular", size: 13) ??
        UIFont.systemFont(ofSize: 13, weight: .regular)
        static let size15 = UIFont(name: "SFProText-Regular", size: 15) ??
        UIFont.systemFont(ofSize: 15, weight: .regular)
        static let size17 = UIFont(name: "SFProText-Regular", size: 17) ??
        UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Bold {
        static let size17 = UIFont(name: "SFProText-Bold", size: 17) ??
        UIFont.systemFont(ofSize: 17, weight: .bold)
        static let size22 = UIFont(name: "SFProText-Bold", size: 22) ??
        UIFont.systemFont(ofSize: 22, weight: .bold)
    }
}
