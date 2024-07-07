//
//  CustomServicesAssembly.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

final class CustomServicesAssembly {
    private let servicesAssembly: ServicesAssembly
    
    init(
        servicesAssembly: ServicesAssembly
    ) {
        self.servicesAssembly = servicesAssembly
    }
    
    func nftServiceCombine() throws -> NftServiceCombine {
        return NftServiceCombineImp(
            networkClient: try combineNetworkClient(),
            storage: servicesAssembly.nftStorage
        )
    }
    
    private func combineNetworkClient() throws -> NetworkClientCombine {
        guard let defaultNetworkClient = servicesAssembly.networkClient as? DefaultNetworkClient else {
            throw NetworkClientError.custom("Network client is not of type DefaultNetworkClient")
        }
        return NetworkClientCombine(baseClient: defaultNetworkClient)
    }
}

