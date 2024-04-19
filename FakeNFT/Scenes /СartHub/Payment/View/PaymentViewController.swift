//
//  Payment.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit
import ProgressHUD

protocol PaymentViewControllerProtocol: AnyObject, ErrorView {
    func reloadCollectionView()
    func displayLoadingIndicator()
    func removeLoadingIndicator()
    func presentView(_ viewController: UIViewController)
    func changeButtonState(color: UIColor, isEnabled: Bool, isLoading: Bool)
    func dismiss()
    func popToRootViewController(animated: Bool)
}

final class PaymentViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let payView: UIView = {
        let payView = UIView()
        payView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        payView.layer.cornerRadius = 12
        payView.backgroundColor = .yaLightGreyDayNight
        payView.translatesAutoresizingMaskIntoConstraints = false
        return payView
    }()
    
    private let payButton: CustomButton = {
        let payButton = CustomButton(
            type: .filled,
            title: TextLabels.PaymentViewController.payButtonTitle,
            action: #selector(payButtonTapped))
        payButton.translatesAutoresizingMaskIntoConstraints = false
        return payButton
    }()
    
    private let payDescription: UILabel = {
        let payDescription = UILabel()
        payDescription.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        payDescription.textColor = .yaWhiteDayNight
        payDescription.text = TextLabels.PaymentViewController.payDescription
        payDescription.translatesAutoresizingMaskIntoConstraints = false
        return payDescription
    }()
    
    private let userAgreementButton: UIButton = {
        let userAgreementButton = UIButton()
        userAgreementButton.setTitle(TextLabels.PaymentViewController.userAgreementTitle, for: .normal)
        userAgreementButton.setTitleColor(.yaBlueUniversal, for: .normal)
        userAgreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        userAgreementButton.isUserInteractionEnabled = true
        userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        return userAgreementButton
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .yaBlackDayNight
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private var presenter: PaymentPresenterProtocol
    
    private var payViewInitialBottomConstraint: NSLayoutConstraint?
    private var payViewFinalBottomConstraint: NSLayoutConstraint?
    private var payViewIsAddedToWindow: Bool = false
    
    // MARK: - Initializers
    init(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        presenter.viewController = self
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPayView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidePayView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        payView.removeFromSuperview()
        payViewIsAddedToWindow = false
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .yaBlackDayNight
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.defaultOffset),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.defaultOffset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        setupPayView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CurrencyCell.self)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = TextLabels.PaymentViewController.navigationTitle
        navigationController?.navigationBar.tintColor = .yaBlackDayNight
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .yaWhiteDayNight
            appearance.shadowColor = nil
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupPayView() {
            
            userAgreementButton.addTarget(self, action: #selector(userAgreementButtonTapped), for: .touchUpInside)
            payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
            
            view.addSubview(payView)
            payViewIsAddedToWindow = true
            [payDescription, userAgreementButton, payButton].forEach { payView.addSubview($0) }
            
            payButton.addSubview(loadingIndicator)
            
            let safeAreaHeight = view.safeAreaInsets.bottom
            
            NSLayoutConstraint.activate([
                payView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                payView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                payDescription.topAnchor.constraint(
                    equalTo: payView.topAnchor, constant: Constants.defaultOffset),
                payDescription.leadingAnchor.constraint(
                    equalTo: payView.leadingAnchor, constant: Constants.defaultOffset),
                payDescription.trailingAnchor.constraint(
                    equalTo: payView.trailingAnchor, constant: -Constants.defaultOffset),
                
                userAgreementButton.topAnchor.constraint(
                    equalTo: payDescription.bottomAnchor, constant: Constants.defaultOffset / 4),
                userAgreementButton.leadingAnchor.constraint(
                    equalTo: payView.leadingAnchor, constant: Constants.defaultOffset),
                
                payButton.topAnchor.constraint(
                    equalTo: userAgreementButton.bottomAnchor, constant: Constants.defaultOffset),
                payButton.leadingAnchor.constraint(
                    equalTo: payView.leadingAnchor, constant: Constants.defaultOffset),
                payButton.trailingAnchor.constraint(
                    equalTo: payView.trailingAnchor, constant: -Constants.defaultOffset),
                payButton.bottomAnchor.constraint(
                    equalTo: payView.bottomAnchor, constant: -(Constants.bottomOffset+safeAreaHeight)),
                payButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
                
                loadingIndicator.centerXAnchor.constraint(equalTo: payButton.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: payButton.centerYAnchor)
            ])
            payViewInitialBottomConstraint = payView.topAnchor.constraint(equalTo: view.bottomAnchor)
            payViewFinalBottomConstraint = payView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
    
    private func showPayView() {
        if !payViewIsAddedToWindow {
            setupPayView()
        }
            
            payViewFinalBottomConstraint?.isActive = false
            payViewInitialBottomConstraint?.isActive = true
            
            view.layoutIfNeeded()
            
            payViewInitialBottomConstraint?.isActive = false
            payViewFinalBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            }
        }
    
    private func hidePayView() {
            payViewFinalBottomConstraint?.isActive = false
            payViewInitialBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            }
        }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let spacing = Constants.collectionViewSpacing
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .estimated(Constants.cellEstimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc private func payButtonTapped() {
        presenter.payButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func refLabelButtonTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let webView = CartWebViewController(ref: url)
        webView.modalPresentationStyle = .fullScreen
        present(webView, animated: true)
    }

    @objc private func userAgreementButtonTapped() {
        presenter.userAgreementButtonTapped()
    }
}

// MARK: - Constants
extension PaymentViewController {
    private enum Constants {
        static let defaultOffset: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        static let bottomOffset: CGFloat = 16
        static let topOffset: CGFloat = 20
        static let cellEstimatedHeight: CGFloat = 46
        static let collectionViewSpacing: CGFloat = 7
    }
}

// MARK: - UICollectionViewDataSource
extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.currenciesCellModel.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            let model = presenter.currenciesCellModel[indexPath.row]
            cell.configureCell(cellModel: model)
            return cell
        }
}

// MARK: - UICollectionViewDelegate
extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexPath)
    }
}

// MARK: - PaymentViewControllerProtocol
extension PaymentViewController: PaymentViewControllerProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func displayLoadingIndicator() {
        ProgressHUD.show()
    }
    
    func removeLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    func presentView(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func changeButtonState(color: UIColor, isEnabled: Bool, isLoading: Bool) {
        payButton.backgroundColor = .yaWhiteDayNight
        payButton.isEnabled = isEnabled
        
        isLoading ? payButton.setTitle("", for: .normal) : payButton.setTitle(TextLabels.PaymentViewController.payButtonTitle, for: .normal)
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }
}
