import Foundation

enum PaymentMethod: Int, CaseIterable {
    
    case bitcoin
    case dogecoin
    case tether
    case apecoin
    case solana
    case ethereum
    case cardano
    case shibaInu
    
    var fullName: String {
        switch self {
        case .bitcoin: return "Bitcoin"
        case .dogecoin: return "Dogecoin"
        case .tether: return "Tether"
        case .apecoin: return "Apecoin"
        case .solana: return "Solana"
        case .ethereum: return "Ethereum"
        case .cardano: return "Cardano"
        case .shibaInu: return "ShibaInu"
        }
    }
    
    var shortName: String {
        switch self {
        case .bitcoin: return "BTC"
        case .dogecoin: return "Doge"
        case .tether: return "USDT"
        case .apecoin: return "APE"
        case .solana: return "SOL"
        case .ethereum: return "ETH"
        case .cardano: return "ADA"
        case .shibaInu: return "SHIB"
        }
    }
}
