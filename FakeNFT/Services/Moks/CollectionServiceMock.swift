import Foundation

final class CollectionServiceMock: CollectionService {
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let collections = self.createMockCollections()
            DispatchQueue.main.async {
                completion(.success(collections))
            }
        }
    }
    
    private func createMockCollections() -> [NFTCollection] {
        let mockCollections = [
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Beige",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige.jpg")!,
                nfts: ["1", "2", "3", "4", "5"],
                description: "Коллекция NFT, вдохновленная теплыми тонами осени.",
                author: "0x742d35Cc6634C0532925a3b8D",
                id: "1"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Blue",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue.jpg")!,
                nfts: ["6", "7", "8"],
                description: "Исследуйте таинственный подводный мир с этой уникальной коллекцией.",
                author: "0x842d35Cc6634C0532925a3b8E",
                id: "2"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Broun",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Broun.jpg")!,
                nfts: ["9", "10", "11", "12"],
                description: "Урбанистические сцены современного мегаполиса.",
                author: "0x942d35Cc6634C0532925a3b8F",
                id: "3"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Green",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Green.jpg")!,
                nfts: ["13", "14"],
                description: "Магические существа древних лесов.",
                author: "0xA42d35Cc6634C0532925a3b8A",
                id: "4"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Peach",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach.jpg")!,
                nfts: ["15", "16", "17", "18", "19", "20"],
                description: "Загадочные образы жарких пустынь.",
                author: "0xB42d35Cc6634C0532925a3b8B",
                id: "5"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Pink",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink.jpg")!,
                nfts: ["21", "22", "23"],
                description: " Коллекция для настоящих любителей альпинизма.",
                author: "0xC42d35Cc6634C0532925a3b8C",
                id: "6"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "White",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White.jpg")!,
                nfts: ["24", "25", "26", "27"],
                description: "Холодная красота арктических ландшафтов.",
                author: "0xD42d35Cc6634C0532925a3b8D",
                id: "7"
            ),
            NFTCollection(
                createdAt: "26.10.2025",
                name: "Yellow",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow.jpg")!,
                nfts: ["28", "29"],
                description: "Теплые и солнечные пейзажи летних долин.",
                author: "0xE42d35Cc6634C0532925a3b8E",
                id: "8"
            )
        ]
        return mockCollections
    }
}
