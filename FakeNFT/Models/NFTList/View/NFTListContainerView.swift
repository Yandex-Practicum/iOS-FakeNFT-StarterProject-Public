//
//  NFTListContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTListContainerView: UIView {
    private let listView = NFTListView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        listView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(listView)

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension NFTListContainerView {
    enum Configuration {
        case loaded([String])
    }

    func configure(configuration: Configuration) {
        switch configuration {
        case let .loaded(items):
            listView.configure(.init(items: items))
        }
    }
}
