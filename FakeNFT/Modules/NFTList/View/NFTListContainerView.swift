//
//  NFTListContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTListContainerView: UIView {
    private lazy var listView = NFTListView { [weak self] index in
        guard let self else { return }
        self.action(.cellSelected(index))
    }
    private let loadingView = NFTLoadingView()
    private lazy var errorView = NFTErrorView { [weak self] in
        guard let self else { return }
        self.action(.reload)
    }
    private let action: (Action) -> Void

    init(action: @escaping (Action) -> Void) {
        self.action = action
        super.init(frame: .null)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        listView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(listView)
        addSubview(loadingView)
        addSubview(errorView)

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),

            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension NFTListContainerView {
    enum Action {
        case cellSelected(IndexPath)
        case reload
    }

    enum Configuration {
        case loading
        case loaded([NFTCollectionModel])
        case error
    }

    func configure(configuration: Configuration) {
        switch configuration {
        case .loading:
            loadingView.isHidden = false
            listView.isHidden = true
            errorView.isHidden = true
        case let .loaded(items):
            loadingView.isHidden = true
            listView.isHidden = false
            errorView.isHidden = true
            listView.configure(.init(items: items))
        case .error:
            loadingView.isHidden = true
            listView.isHidden = true
            errorView.isHidden = false
        }
    }
}
