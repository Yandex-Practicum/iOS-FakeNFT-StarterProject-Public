//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 14.12.2023.
//

import UIKit

final class PaymentViewController: UIViewController {
    private var viewModel: PaymentViewModel
    private let collectionSettings = CollectionSettings(
        cellCount: 2,
        topDistance: 20,
        bottomDistance: 0,
        leftDistance: 16,
        rightDistance: 16,
        cellSpacing: 7
    )

    // MARK: - UiElements
    private let navigationBar = UINavigationBar()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Select.a.Payment.Method", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "YPBackward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonActions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PaymentCell.self, forCellWithReuseIdentifier: "PaymentCell")
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: Initialisation
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        configNavigationBar()
        bind()
    }

    // MARK: Binding
    private func bind() {
        viewModel.$currencies.bind(observer: { [weak self] _ in
            guard let self else { return }
        })
    }

    // MARK: - Actions
    @objc private func backButtonActions() {
        dismiss(animated: true)
    }

    // MARK: - Private methods
    private func configNavigationBar() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.titleView = titleLabel
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = UIColor(named: "YPWhite")
        navigationBar.shadowImage = UIImage()
        navigationBar.setItems([navigationItem], animated: false)
    }

    private func configViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        [navigationBar, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 499)
        ])
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({
            collectionView.deselectItem(at: $0, animated: false)
            let cell = collectionView.cellForItem(at: $0) as? PaymentCell
            cell?.selectedItem(isSelected: false)
        })
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell
        cell?.selectedItem(isSelected: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell
        cell?.selectedItem(isSelected: false)
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PaymentCell",
            for: indexPath
        ) as? PaymentCell else { return UICollectionViewCell() }
        cell.configureCell(with: viewModel.currencies[indexPath.row])
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionSettings.paddingWidth
        let cellWidth =  availableWidth / CGFloat(collectionSettings.cellCount)
        return CGSize(width: cellWidth, height: 46)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: collectionSettings.topDistance,
            left: collectionSettings.leftDistance,
            bottom: collectionSettings.bottomDistance,
            right: collectionSettings.rightDistance
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionSettings.cellSpacing
    }
}
