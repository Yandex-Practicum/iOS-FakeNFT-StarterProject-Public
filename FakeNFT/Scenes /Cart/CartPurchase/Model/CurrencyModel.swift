import UIKit

struct CurrencyServerModel: Decodable {
    let id: String
    let title: String
    let name: String
    let image: URL
}

struct CurrencyModel: Hashable {
    let id: String
    let title: String
    let name: String
    let image: URL
    
    init(serverModel: CurrencyServerModel) {
        id = serverModel.id
        title = serverModel.title
        name = serverModel.name
        image = serverModel.image
    }
}
