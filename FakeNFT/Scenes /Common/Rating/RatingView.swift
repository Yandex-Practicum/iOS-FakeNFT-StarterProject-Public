//
//  RatingView.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import UIKit

class RatingView: UIView {
    
    // MARK: - Private Properties
    
    private let maxRating = 5
    private let starSize: CGFloat = 12
    private let starSpacing: CGFloat = 2
    
    private var viewModel: RatingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var starImageViews: [UIImageView] = []
    
    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = starSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(frame: CGRect, viewModel: RatingViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupStackView()
        setupStars()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        viewModel.$rating
            .receive(on: RunLoop.main)
            .sink { [weak self] rating in
                self?.updateStars(rating)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupStars() {
        for _ in 0..<maxRating {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "star_no_active")
            starImageViews.append(imageView)
            stackView.addArrangedSubview(imageView)
        }
    }
    
    private func updateStars(_ rating: Int) {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.image = index < rating ? UIImage(named: "star_active") : UIImage(named: "star_no_active")
        }
    }
}
