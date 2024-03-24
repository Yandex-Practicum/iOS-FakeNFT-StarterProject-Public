//
//  ProfileCell.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import UIKit
import SnapKit

// MARK: - Profile TableView Cell
final class ProfileCell: UITableViewCell {
    // MARK: - Public properties
    public static let cellID = String(describing: ProfileCell.self)

    // MARK: - UI
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var counter: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = UIColor(named: "ypUniBlack")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    public func configureCell(label: String?, value: String?) {
        if let label = label {
            title.text = label
        }

        if let value = value {
            counter.text = value
        }
    }
}

private extension ProfileCell {
    // MARK: - Setup Views
    func setupViews() {
        [title,
         counter,
         arrowImageView
        ].forEach {
            self.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        counter.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(title.snp.trailing).offset(8)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
