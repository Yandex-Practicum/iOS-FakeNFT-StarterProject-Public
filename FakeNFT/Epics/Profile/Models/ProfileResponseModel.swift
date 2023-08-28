import Foundation

/// Модель ответа для профиля пользователя.
struct ProfileResponseModel: Codable, Equatable {
    /// Имя пользователя.
    let name: String
    /// Ссылка на аватар пользователя.
    let avatar: String
    /// Описание пользователя.
    let description: String
    /// Ссылка на вебсайт пользователя.
    let website: URL
    /// Список идентификаторов NFT пользователя.
    let nfts: [String]
    /// Список идентификаторов лайков пользователя.
    let likes: [String]
    /// Идентификатор пользователя.
    let id: String
}
