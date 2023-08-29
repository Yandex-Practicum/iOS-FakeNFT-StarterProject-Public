//
//  AnimatableCollectionViewCell.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 06.08.2023.
//

import UIKit

protocol AnimatableCollectionViewCell: UICollectionViewCell {
    func highlightAnimation()
}

extension AnimatableCollectionViewCell {
    func highlightAnimation() {
        UIView.animate(
            withDuration: 0.08,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.92, y: 0.92) : CGAffineTransform.identity
            },
            completion: nil
        )
    }
}
