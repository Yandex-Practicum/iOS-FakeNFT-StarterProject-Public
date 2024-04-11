//
//  SpecialRatingView.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 11.04.2024.
//

import Foundation
import UIKit

final class SpecialRatingView: UIViewController {
    //MARK: - Public Properties
    var imageViewArray: [UIImageView] = []
    
    // MARK: - Private Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0.75
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingTheLayoutOfScreenElements()
    }
    // MARK: - Public Methods
    func ratingVisualization(rating: Int) {
        for i in 0..<5 {
            switch rating {
            case i:
                imageViewArray[i].image = UIImage(named: "activeStar")
            default:
                imageViewArray[i].image = UIImage(named: "noActiveStar")
            }
        }
    }
    // MARK: - Private Methods
    private func customizingTheLayoutOfScreenElements() {
        view.addSubview(stackView)
        
        for i in 1...5 {
            stackView.addArrangedSubview(imageViewArray[i])
        }
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}
