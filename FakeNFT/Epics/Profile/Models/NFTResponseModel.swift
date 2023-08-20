import Foundation

/// Модель ответа для NFT токена.
struct NFTResponseModel: Decodable {
    /// Дата создания NFT.
    let createdAt: String
    /// Название NFT.
    let name: String
    /// Список ссылок на изображения NFT.
    let images: [String]
    /// Рейтинг NFT.
    let rating: Int
    /// Описание NFT.
    let description: String
    /// Цена NFT.
    let price: Double
    /// Автор NFT.
    let author: String
    /// Идентификатор NFT.
    let id: String
}
