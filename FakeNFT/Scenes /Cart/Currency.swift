import UIKit

enum Currency: String, CaseIterable {
    case bitcoin = "Bitcoin"
    case dogecoin = "Dogecoin"
    case tether = "Tether"
    case apecoin = "Apecoin"
    case solana = "Solana"
    case etherium = "Etherium"
    case cardano = "Cardano"
    case shibaInu = "Shiba Inu"
    
    var shortNames: String {
        switch self {
        case .bitcoin:
            return "BTC"
        case .dogecoin:
            return "DOGE"
        case .tether:
            return "USDT"
        case .apecoin:
            return "APE"
        case .solana:
            return "SOL"
        case .etherium:
            return "ETH"
        case .cardano:
            return "ADA"
        case .shibaInu:
            return "SHIB"
        }
    }
    
    var currencyImages: UIImage? {
        switch self {
        case .bitcoin:
            return CurrencyAssets.bitcoinImage
        case .dogecoin:
            return CurrencyAssets.dogecoinImage
        case .tether:
            return CurrencyAssets.tetherImage
        case .apecoin:
            return CurrencyAssets.apecoinImage
        case .solana:
            return CurrencyAssets.solanaImage
        case .etherium:
            return CurrencyAssets.etheriumImage
        case .cardano:
            return CurrencyAssets.cardanoImage
        case .shibaInu:
            return CurrencyAssets.shibaInuImage
        }
    }
}
