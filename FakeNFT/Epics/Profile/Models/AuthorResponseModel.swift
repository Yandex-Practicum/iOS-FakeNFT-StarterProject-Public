import Foundation

/// Модель ответа для автора NFT.
struct AuthorResponseModel: Codable {
    /// Имя автора.
    let name: String
    /// Ссылка на аватар автора.
    let avatar: String
    /// Описание автора.
    let description: String
    /// Ссылка на вебсайт автора.
    let website: String
    /// Список идентификаторов NFT автора.
    let nfts: [String]
    /// Рейтинг автора.
    let rating: String
    /// Идентификатор автора.
    let id: String
}
