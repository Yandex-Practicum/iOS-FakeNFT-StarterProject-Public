//
//  NFTListContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTListContainerView: UIView {
    private let listView = NFTListView()
    private let loadingView = NFTLoadingView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        listView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(listView)
        addSubview(loadingView)

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension NFTListContainerView {
    enum Configuration {
        case loading
        case loaded([String])
    }

    func configure(configuration: Configuration) {
        switch configuration {
        case .loading:
            listView.isHidden = true
        case let .loaded(items):
            listView.configure(.init(items: items))
            loadingView.isHidden = true
        }
    }
}
