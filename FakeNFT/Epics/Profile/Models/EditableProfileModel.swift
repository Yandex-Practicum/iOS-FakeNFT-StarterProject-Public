import UIKit

/// Модель редактируемого профиля пользователя.
struct EditableProfileModel {
    /// Имя пользователя.
    let name: String
    /// Ссылка на аватар пользователя.
    let avatar: String
    /// Аватар пользователя в виде изображения.
    let avatarImage: UIImage?
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
