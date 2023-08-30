import UIKit

enum Resources {
    enum Images {
        enum SplashScreen {
            static let logo = UIImage(named: "Vector")
        }
        
        enum Onboarding {
            static let firstImage = UIImage(named: "Onboarding1")
            static let secondImage = UIImage(named: "Onboarding2")
            static let thirdImage = UIImage(named: "Onboarding3")
            static let cancelButton = UIImage(systemName: "multiply")?.withTintColor(.whiteDay, renderingMode: .alwaysOriginal)
        }
        
        enum TabBar {
            static let profileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let profileImageSelected = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let catalogImage = UIImage(systemName: "rectangle.stack.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let catalogImageSelected = UIImage(systemName: "rectangle.stack.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let cartImage = UIImage(named: "cartBasket")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let cartImageSelected = UIImage(named: "cartBasket")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let statisticImage = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let statisticImageSelected = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
        }
        
        enum NavBar {
            static let sortIcon = UIImage(systemName: "text.justify.leading")
        }
        
        enum NFTCollectionCell {
            static let unlikedButton = UIImage(systemName: "heart.fill")?.withTintColor(.whiteUniversal, renderingMode: .alwaysOriginal)
            static let likedButton = UIImage(systemName: "heart.fill")?.withTintColor(.redUniversal, renderingMode: .alwaysOriginal)
            static let grayRatingStar = UIImage(systemName: "star.fill")?.withTintColor(.lightGrayDay, renderingMode: .alwaysOriginal)
            static let goldRatingStar = UIImage(systemName: "star.fill")?.withTintColor(.yellowUniversal, renderingMode: .alwaysOriginal)
            static let putInBasket = UIImage(named: "emptyCart")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let removeFromBasket = UIImage(named: "removeBasket")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
        }
        
        enum NFTBrowsing {
            static let cancellButton = UIImage(systemName: "xmark")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
        }
        
        enum NotificationBanner {
            static let notificationBannerImage = UIImage(systemName: "antenna.radiowaves.left.and.right.slash")
        }
    }
    
    enum Network {
        
        enum MockAPI {
            static let defaultStringURL = "https://64c516a6c853c26efada7a11.mockapi.io"
            
            enum Paths {
                static let currencies = "/api/v1/currencies"
                static let nftCollection = "/api/v1/collections"
                static let nftCard = "/api/v1/nft"
                static let orders = "/api/v1/orders/1"
                static let orderPayment = "/api/v1/orders/1/payment"
                static let profile = "/api/v1/profile/1"
                static let users = "/api/v1/users"
            }
        }
        
        static let metricaAPIKey = "de532bb8-8a8d-4118-94ad-dbde6f544bf6"
        
        enum NFTBrowser {
            static let bitcoin =  "https://bitcoin.org/ru/"
            static let dogecoin = "https://dogecoin.com"
            static let tether = "https://tether.to/ru/"
            static let apecoin = "https://apecoin.com"
            static let solana = "https://solana.com/ru"
            static let ethereum = "https://ethereum.org/en/"
            static let cordano = "https://cardano.org"
            static let shibainu = "https://www.shibatoken.com"
        }
    }
}
