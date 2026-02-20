struct CatalogMockProvider: CatalogProviderProtocol {
    func loadCatalog(completion: @escaping (Result<[Catalog], Error>) -> Void) {
        completion(.success([
            Catalog(
                createdAt: "",
                name: "Neo City",
                cover: "Catalog",
                nfts: ["nft_1", "nft_2", "nft_3"],
                description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
                author: "Автор коллекции: Demo Author",
                website: "",
                id: "collection_1"
            ),
            Catalog(
                createdAt: "",
                name: "Abstract Shapes",
                cover: "StarsActive",
                nfts: ["nft_4", "nft_5"],
                description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
                author: "Автор коллекции: Demo Author",
                website: "",
                id: "collection_2"
            ),
            Catalog(
                createdAt: "",
                name: "Pixel Heroes",
                cover: "Basket",
                nfts: ["nft_6"],
                description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
                author: "Автор коллекции: Demo Author",
                website: "",
                id: "collection_3"
            )
        ]))
    }
}







