import Foundation

final class CollectionServiceMock: CollectionService {
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        // Имитируем задержку сети
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let collections = self.createMockCollections()
            DispatchQueue.main.async {
                completion(.success(collections))
            }
        }
    }
    
    private func createMockCollections() -> [NFTCollection] {
        let mockCollections = [
            NFTCollection(
                createdAt: "2024-01-15T10:00:00Z",
                name: "Beige",
                cover: "Beige",
                nfts: ["1", "2", "3", "4", "5"],
                description: "Коллекция NFT, вдохновленная космическими исследованиями",
                author: "Me",
                id: "1"
            ),
            NFTCollection(
                createdAt: "2024-01-16T11:30:00Z",
                name: "Blue",
                cover: "Blue",
                nfts: ["6", "7", "8"],
                description: "Исследуйте таинственный подводный мир",
                author: "ME",
                id: "2"
            ),
            NFTCollection(
                createdAt: "2024-01-17T14:20:00Z",
                name: "Broun",
                cover: "Broun",
                nfts: ["9", "10", "11", "12"],
                description: "Урбанистические сцены современного мегаполиса",
                author: "Me",
                id: "3"
            ),
            NFTCollection(
                createdAt: "2024-01-18T09:15:00Z",
                name: "Green",
                cover: "Green",
                nfts: ["13", "14"],
                description: "Магические существа древних лесов",
                author: "Me",
                id: "4"
            ),
            NFTCollection(
                createdAt: "2024-01-19T16:45:00Z",
                name: "Peach",
                cover: "Peach",
                nfts: ["15", "16", "17", "18", "19", "20"],
                description: "Загадочные образы жарких пустынь",
                author: "Me",
                id: "5"
            ),
            NFTCollection(
                createdAt: "2024-01-20T12:00:00Z",
                name: "Grayо",
                cover: "Gray",
                nfts: ["21", "22", "23"],
                description: "Инновационные технологии завтрашнего дня",
                author: "Me",
                id: "6"
            ),
            NFTCollection(
                createdAt: "2024-01-21T15:30:00Z",
                name: "Pink",
                cover: "Pink",
                nfts: ["24", "25", "26", "27"],
                description: "Нежные и романтичные образы",
                author: "Me",
                id: "7"
            ),
            NFTCollection(
                createdAt: "2024-01-22T08:45:00Z",
                name: "White",
                cover: "White",
                nfts: ["28", "29"],
                description: "Минималистичные и светлые работы",
                author: "Me",
                id: "8"
            ),
            NFTCollection(
                createdAt: "2024-01-23T17:20:00Z",
                name: "Yellow",
                cover: "Yellow",
                nfts: ["30", "31", "32", "33", "34"],
                description: "Яркие и позитивные произведения",
                author: "Me",
                id: "9"
            )
        ]
        return mockCollections
    }
}
