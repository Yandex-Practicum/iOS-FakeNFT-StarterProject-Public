//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 13.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Properties & UI Elemenst
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "person.circle")
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProBold22
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProRegular13
        label.textColor = .ypBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var webLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlueUn
        label.font = .sfProRegular15
        label.isUserInteractionEnabled = true
        label.text = "https://github.com/iamjohansson"
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
    }
    
    @objc func didTapEditButton() {
        // TODO: на экран редактирования
    }
}
