import UIKit

extension UIImage {
    
    enum NFTIcon {
        static let cart = UIImage(named: "Cart") ?? UIImage(systemName: "bag.fill")!
        static let cartAdd = UIImage(named: "CartAdd") ?? UIImage(systemName: "bag.badge.plus")!
        static let cartDelete = UIImage(named: "CartDelete") ?? UIImage(systemName: "bag.badge.minus")!
        static let catalogue = UIImage(named: "Catalogue") ?? UIImage(systemName: "square.stack.fill")!
        static let chevronLeft = UIImage(named: "Chevron") ?? UIImage(systemName: "chevron.left")!
        static let liked = UIImage(named: "Liked") ?? UIImage(systemName: "heart.fill")!
        static let notLiked = UIImage(named: "NotLiked") ?? UIImage(systemName: "heart")!
        static let profile = UIImage(named: "Profile") ?? UIImage(systemName: "person.crop.circle.fill")!
        static let sorting = UIImage(named: "Sorting") ?? UIImage(systemName: "arrow.up.arrow.down.circle.fill")!
        static let statistics = UIImage(named: "Statistics") ?? UIImage(systemName: "flag.2.crossed.fill")!
        static let xmark = UIImage(named: "Xmark") ?? UIImage(systemName: "xmark")!
        
        static let zeroStars = UIImage(named: "ZeroStars") ?? UIImage(systemName: "star")!
        static let oneStar = UIImage(named: "OneStar") ?? UIImage(systemName: "star")!
        static let twoStars = UIImage(named: "TwoStars") ?? UIImage(systemName: "star")!
        static let threeStars = UIImage(named: "ThreeStars") ?? UIImage(systemName: "star")!
        static let fourStars = UIImage(named: "FourStars") ?? UIImage(systemName: "star")!
        static let fiveStars = UIImage(named: "FiveStars") ?? UIImage(systemName: "star")!
    }
}
