//
//  ProfileMainTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 16.07.2023.
//

import UIKit
import Combine

final class ProfileMainTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: ProfileTableCellViewModel? {
        didSet {
            viewModel?.$descriptionRow
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] model in
                    self?.updateUI(with: model)
                })
                .store(in: &cancellables)
        }
    }

    private lazy var profileInfoButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.textAlignment = .natural
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI(with model: ProfileModel) {
        profileInfoButton.setTitle(model.itemDescriprion, for: .normal)
    }
    
}

// MARK: - Ext Constraints
private extension ProfileMainTableViewCell {
    func setupConstraints() {
        setupButton()
    }
    
    func setupButton() {
        addSubview(profileInfoButton)
        profileInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileInfoButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileInfoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
}
