//
//  NFTsContainerView.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

final class NFTsContainerView: UIView {
    enum ViewEvent {
        case cellSelected(IndexPath)
        case reload
    }

    enum ViewState {
        case loading
        case loaded([NFTCollectionModel])
        case error
    }

    private let eventHandler: EventHandler<ViewEvent>
    
    private lazy var listView: NFTListView = {
        let view = NFTListView { [weak self] index in
            self?.eventHandler(.cellSelected(index))
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingView: UIView = {
        let view = NFTLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorView: UIView = {
        let view = NFTErrorView { [weak self] in
            self?.eventHandler(.reload)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(handler: @escaping EventHandler<ViewEvent>) {
        self.eventHandler = handler
        super.init(frame: .null)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTsContainerView -> init(coder:) has not been implemented"
        )
    }
    
    func configure(for state: ViewState) {
        switch state {
        case .error:
            loadingView.isHidden = true
            listView.isHidden = true
            errorView.isHidden = false
        case .loading:
            loadingView.isHidden = false
            listView.isHidden = true
            errorView.isHidden = true
        case let .loaded(items):
            loadingView.isHidden = true
            listView.isHidden = false
            errorView.isHidden = true
            listView.configure(with: items)
        }
    }


    private func setupViews() {
        addSubview(listView)
        addSubview(loadingView)
        addSubview(errorView)
        
        let constraints = [
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
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

