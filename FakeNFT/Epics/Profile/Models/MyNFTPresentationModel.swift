import Foundation

/// Модель представления NFT пользователя.
struct MyNFTPresentationModel {
    /// Название NFT.
    let nftName: String
    /// Имя автора NFT.
    let authorName: String
    /// Ссылка на изображение NFT.
    let image: String
    /// Цена NFT.
    let price: Double
    /// Рейтинг NFT.
    let rating: String
    /// Флаг, указывающий на то, что NFT в списке избранных.
    let isLiked: Bool
    
    let id: String
}
