//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 10.12.2023.
//

import Foundation

final class CartViewModel {
    @Observable var nfts: [Nft] = []
    private let service: CartService
    private let id = "1"

    // MARK: Initialisation
    init(service: CartService) {
        self.service = service
        loadNfts()
    }

    // MARK: - Methods 
    func viewDidLoad() {
        loadNfts()
    }

    func countingTheTotalAmount() -> Float {
        var total: Float = 0.0
        nfts.forEach {
            total += $0.price
        }
        return roundToTwoDecimalPlaces(total)
    }

    func removeItemFromCart(idNFT: String) {
        nfts.removeAll(where: {
            $0.id == idNFT
        })
        let nftsID = nfts.map { $0.id }
        service.removingFromCart(id: id, nftsID: nftsID) {_ in }
    }

    // MARK: - Private methods
    private func roundToTwoDecimalPlaces(_ value: Float) -> Float {
        let divisor = pow(10.0, Float(2))
        return (value * divisor).rounded() / divisor
    }

    private func loadNfts() {
        service.downloadServiceNFTs(with: id) { result in
            switch result {
            case .success(let nfts):
                self.nfts = nfts
            case .failure(let error):
                print("Error loading NFTs: \(error)")
            }
        }
    }
}
