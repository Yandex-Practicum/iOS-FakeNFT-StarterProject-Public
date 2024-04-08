//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 03.04.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK:  - Public Properties
    let servicesAssembly: ServicesAssembly
    
    //MARK:  - Private Properties
    private let tableСell = ["Мой NFT", "Избранные NFT", "О разработчике"]
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "square.and.pencil"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(editButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatar")
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.text = "Joaquin Phoenix"
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular13
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.text = "Дизайнер из Казани, люблю цифровое искусство\n и бейглы. В моей коллекции уже 100+ NFT,\n и еще больше — на моём сайте. Открыт\n к коллаборациям."
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()
    
    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular15
        label.text = "Joaquin Phoenix.com"
        label.textColor = UIColor(named: "ypBlueUn")
        return label
    }()
    
    private lazy var smollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.backgroundColor = UIColor(named: "ypWhite")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bigStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.backgroundColor = UIColor(named: "ypWhite")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.cellID
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Action
    @objc func editButtonTap() {
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
    }
    //MARK: - Private Methods
    func customizingNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func customizingScreenElements() {
        view.backgroundColor = .systemBackground
        
        [profileImage, nameLabel].forEach {smollStackView.addArrangedSubview($0)}
        [smollStackView, descriptionLabel, siteLabel].forEach {bigStackView.addArrangedSubview($0)}
        [bigStackView, profileTableView].forEach {view.addSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        bigStackView.setCustomSpacing(8, after: descriptionLabel)
        
        NSLayoutConstraint.activate([
            bigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bigStackView.heightAnchor.constraint(equalToConstant: 198),
            
            smollStackView.topAnchor.constraint(equalTo: bigStackView.topAnchor),
            smollStackView.leadingAnchor.constraint(equalTo: bigStackView.leadingAnchor),
            smollStackView.trailingAnchor.constraint(equalTo: bigStackView.trailingAnchor),
            smollStackView.heightAnchor.constraint(equalToConstant: 70),
            
            profileTableView.topAnchor.constraint(equalTo: bigStackView.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileTableView.heightAnchor.constraint(equalToConstant: 162),
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableСell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.cellID,for: indexPath) as? ProfileCell else {fatalError("Could not cast to CategoryCell")}
        
        let name = tableСell[indexPath.row]
        let number = "(112)"
        cell.changingLabels(nameView: name, numberView: number)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = MyNFTViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
