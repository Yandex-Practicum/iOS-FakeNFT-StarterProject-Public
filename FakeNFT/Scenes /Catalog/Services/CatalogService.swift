//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

protocol CatalogServiceProtocol {
    var catalogServicePublisher: Published<Array<Catalog>>.Publisher { get }
    var catalog: [Catalog] { get }
    func fetchCatalog()
}

final class CatalogService: CatalogServiceProtocol {
    
    //MARK: - Public properties
    @Published var catalog: [Catalog] = []
    var catalogServicePublisher: Published<Array<Catalog>>.Publisher { $catalog }
    
    //MARK: - Private properties
    private let request = CatalogRequest()
    private let networkClient: NetworkClient
    private var task: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = DefaultNetworkClient()
    }
    
    //MARK: - Public methods
    func fetchCatalog() {
        
        let _ = networkClient
            .send(request: request, type: [CatalogResult].self, onResponse: { [weak self] (result: Result<[CatalogResult], Error>)  in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let catalogRes):
                        catalog += catalogRes.map {
                            Catalog(
                                name: $0.name,
                                coverURL: URL(string: $0.cover),
                                nfts: $0.nfts,
                                desription: $0.description,
                                authorID: $0.author,
                                id: $0.id)
                        }
                    case .failure(_):
                        print("error")
                    }
                }
            })
    }
}
