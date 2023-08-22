import UIKit

extension UIImage {
    enum Icons {
        static let cart = UIImage.named(AppConstants.Icons.cart)
        static let catalog = UIImage.named(AppConstants.Icons.catalog)
        static let profile = UIImage.named(AppConstants.Icons.profile)
        static let statistics = UIImage.named(AppConstants.Icons.statistics)
        static let close = UIImage.named("Close")
        static let sort = UIImage.named("Sort")

        static let star = UIImage(systemName: "star.fill")
    }

    enum Cart {
        enum PaymentResult {
            static let success = UIImage.named("CartPaymentSuccess")
            static let failure = UIImage.named("CartPaymentFailure")
        }

        static let active = UIImage.named("CartActive")
        static let nonActive = UIImage.named("CartNonActive")
    }

    enum Add {
        static let active = UIImage.named("AddActive")
        static let done = UIImage.named("AddDone")
    }

    enum Favourite {
        static let active = UIImage.named("FavouriteActive")
        static let nonActive = UIImage.named("FavouriteNonActive")
    }

    enum Currencies {
        static let apeCoin = UIImage.named("ApeCoin")
        static let bitcoin = UIImage.named("Bitcoin")
        static let cardano = UIImage.named("Cardano")
        static let dogecoin = UIImage.named("Dogecoin")
        static let etherium = UIImage.named("Ethereum")
        static let shibaInu = UIImage.named("Shiba Inu")
        static let solana = UIImage.named("Solana")
        static let tether = UIImage.named("Tether")
    }
}

private extension UIImage {
    static func named(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {
            assertionFailure("Cannot load image with name: \(named)")
            return UIImage()
        }
        return image
    }
}
