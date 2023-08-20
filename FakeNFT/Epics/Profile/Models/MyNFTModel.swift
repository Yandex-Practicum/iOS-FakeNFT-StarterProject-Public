import Foundation

/// Модель NFT пользователя.
struct MyNFCModel: Codable {
    /// Название NFT.
    let nftName: String
    /// Имя автора NFT.
    let authorName: String
    /// Список ссылок на изображения NFT.
    let images: [String]
    /// Цена NFT.
    let price: Double
    /// Рейтинг NFT.
    let rating: String
    /// Идентификатор NFT.
    let id: String
}
