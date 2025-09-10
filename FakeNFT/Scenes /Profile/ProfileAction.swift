import UIKit

enum ProfileAction: String, CaseIterable {
    case myNFT = "ViewProfile.MyNFT"
    case favoriteNFT = "ViewProfile.Favorites"

    var localizedTitle: String {
        NSLocalizedString(rawValue, comment: "")
    }

    func count(from profile: Profile) -> Int? {
        switch self {
        case .myNFT: return profile.nfts.count
        case .favoriteNFT: return profile.likes.count
        }
    }

    func makeViewController(profile: Profile,
                            servicesAssembly: ServicesAssembly) -> UIViewController? {
        switch self {
        case .myNFT:
            // TODO: create my nfts vc
            let vc = MyNftViewController(/*servicesAssembly: servicesAssembly, nftIDs: profile.nfts*/)
            return vc
        case .favoriteNFT:
            // TODO: create favs vc
            let vc = FavoriteNftViewController(/*servicesAssembly: servicesAssembly, nftIDs: profile.likes*/)
            return vc
        }
    }
}
