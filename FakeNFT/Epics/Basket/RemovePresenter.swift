//
//  RemovePresenter.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 21/08/2023.
//

import Foundation

class RemoveNFTPresenter {
    weak var view: RemoveNFTView?
    weak var delegate: RemoveNFTViewControllerDelegate?
    private var model: NftModel?

    init(view: RemoveNFTView, delegate: RemoveNFTViewControllerDelegate?) {
        self.view = view
        self.delegate = delegate
    }

    func configure(with model: NftModel) {
        self.model = model
        if
            let image = model.images.first,
            let url = URL(string: image) {
            view?.updateImage(with: url)
        }
    }
    
    func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    func didTapConfirmButton() {
        guard let model = model else { return }
        delegate?.didTapConfirmButton(model)
    }
}
