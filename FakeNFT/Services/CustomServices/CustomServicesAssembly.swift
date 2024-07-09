//
//  CustomServicesAssembly.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 28/06/2024.
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
    
    func createProfileViewController() throws -> ProfileViewController {
        let nftServiceCombine = try self.nftServiceCombine()
        return ProfileViewController()
    }
    
    func createCartViewController() throws -> CartViewController {
        let nftServiceCombine = try self.nftServiceCombine()
        let cartViewModel = CartViewModel(unifiedService: nftServiceCombine)
        return CartViewController(cartViewModel: cartViewModel, unifiedService: nftServiceCombine)
    }
    
    private func combineNetworkClient() throws -> NetworkClientCombine {
        guard let defaultNetworkClient = servicesAssembly.networkClient as? DefaultNetworkClient else {
            throw NetworkClientError.custom("Network client is not of type DefaultNetworkClient")
        }
        return NetworkClientCombine(baseClient: defaultNetworkClient)
    }
}

