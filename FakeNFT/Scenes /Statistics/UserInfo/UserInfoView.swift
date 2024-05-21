//
//  UserInfoView.swift
//  FakeNFT
//
//  Created by Сергей on 23.04.2024.
//

import UIKit
import Kingfisher

protocol UserInfoViewControllerProtocol {
    var presenter: UserInfoPresenterProtocol { get set }
}

final class UserInfoView: UIViewController & UserInfoViewControllerProtocol {

    var presenter: UserInfoPresenterProtocol = UserInfoPresenter()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing  = 16
        return stackView
    }()

    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private let descriptonText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        textView.font = .systemFont(ofSize: 13, weight: .regular)
        return textView
    }()

    private lazy var webButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var nftCollection: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()

    init(object: Person) {
        presenter.object = object
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        set()

    }

    private func setViews() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        stackView.addArrangedSubview(avatarImage)
        stackView.addArrangedSubview(nameLabel)
        [stackView, descriptonText, webButton, nftCollection].forEach {
            view.addSubview($0)
        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            descriptonText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptonText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptonText.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            webButton.topAnchor.constraint(equalTo: descriptonText.bottomAnchor, constant: 28),
            webButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webButton.heightAnchor.constraint(equalToConstant: 40),
            nftCollection.topAnchor.constraint(equalTo: webButton.bottomAnchor, constant: 40),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollection.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func set() {
        guard let object = presenter.object else { return }
        let url = URL(string: object.avatar)
        nameLabel.text = presenter.object?.name
        descriptonText.text = presenter.object?.description
        avatarImage.kf.setImage(with: url)
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func webButtonTapped() {
        navigationController?.pushViewController(WebViewController(url: presenter.object?.website ?? ""), animated: true)
    }
}

extension UserInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NFTTableViewCell", for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        let arrowImage = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let arrowImageView = UIImageView(image: arrowImage)
        cell.accessoryView = arrowImageView
        cell.selectionStyle = .none
        let count = presenter.object?.nfts.count ?? Int()
        cell.set(nftCount: count)
        return cell
    }
}

extension UserInfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let object = presenter.object?.nfts else { return }
        let vc = UserNFTCollectionView(nft: object)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
