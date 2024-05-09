//
//  DeleteCardPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation
import UIKit

protocol DeleteCardPresenterProtocol {
    
    var nftImage: UIImage { get }
    func deleteNFTfromCart(completion: @escaping (Result<[String], Error>) -> Void)
}

final class DeleteCardPresenter: DeleteCardPresenterProtocol {    
    
    private weak var viewController: CartDeleteControllerProtocol?
    private var nftIdForDelete: String
    private (set) var nftImage: UIImage
    
    init(viewController: CartDeleteControllerProtocol, nftIdForDelete: String, nftImage: UIImage) {
        self.viewController = viewController
        self.nftIdForDelete = nftIdForDelete
        self.nftImage = nftImage
    }
    
    func deleteNFTfromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        viewController?.startLoadIndicator()
        //TODO: реализовать удаление
    }
    
}
