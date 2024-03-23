//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import UIKit
import SnapKit

final class ProfileView: UIView {

    // MARK: - Properties
    private let tableViewLabels: [String] = [
        L10n.Profile.myNFT,
        L10n.Profile.favoritesNFT,
        L10n.Profile.aboutDeveloper
    ]

    // MARK: - UI
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar_icon")
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix"
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    // swiftlint:disable all
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Дизайнер из Казани, люблю цифровое искусство\nи бейглы. В моей коллекции уже 100+ NFT,\nи еще больше — на моём сайте. Открыт\nк коллаборациям."
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    // swiftlint:enable all

    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix.com"
        label.textColor = UIColor(named: "ypUniBlue")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.cellID
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileView {
    // MARK: - SetupViews
    func setupViews() {
        [avatarImageView,
         nameLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [stackView,
         descriptionLabel,
         siteLabel
        ].forEach {
            userInfoStackView.addArrangedSubview($0)
        }

        userInfoStackView.setCustomSpacing(8, after: descriptionLabel)

        [userInfoStackView,
         tableView
        ].forEach {
            self.addSubview($0)

        }
    }

    // MARK: - SetupConstraints
    func setupConstraints() {
        let cellHeight = CGFloat(54)

        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cellHeight * 3)
        }
    }
}

extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewLabels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.cellID,
            for: indexPath
        ) as? ProfileCell else {
            fatalError("Could not cast to ProfileCell")
        }
        cell.configureCell(
            label: tableViewLabels[indexPath.row],
            value: "(112)"
            // заменить моковые данные
        )
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileView: UITableViewDelegate {

}
