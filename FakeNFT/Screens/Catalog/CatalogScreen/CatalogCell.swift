//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import UIKit

final class CatalogCell: UITableViewCell, ReuseIdentifying {

    private lazy var catalogCellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var catalogNameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func setupUI() {
        [catalogCellImage, catalogNameLabel].forEach { view in
            contentView.addSubview(view)
        }

        contentView.backgroundColor = .white

        catalogCellImage.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.top.leading.trailing.equalTo(contentView)
        }

        catalogNameLabel.snp.makeConstraints { make in
            make.top.equalTo(catalogCellImage.snp.bottom).offset(4)
            make.leading.equalTo(contentView)
        }
    }

    func setCellImage(with url: URL?) {
        self.catalogCellImage.kf.setImage(with: url)
    }

    func setNameLabel(with text: String) {
        self.catalogNameLabel.text = text
    }
}
