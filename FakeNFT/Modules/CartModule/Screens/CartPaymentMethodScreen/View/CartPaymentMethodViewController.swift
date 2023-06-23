//
//  CartPaymentMethodViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import UIKit

protocol CartPaymentMethodCoordinatableProtocol {
    var onProceed: (() -> Void)? { get set }
    var onTapUserLicense: (() -> Void)? { get set }
}

final class CartPaymentMethodViewController: UIViewController, CartPaymentMethodCoordinatableProtocol {
    var onProceed: (() -> Void)?
    var onTapUserLicense: (() -> Void)?
    
    private let viewModel: CartPaymentMethodViewModel
    private let dataSource: PaymentMethodDSManagerProtocol
    
    private enum GridItemSize: CGFloat {
        case half = 0.5
    }
   
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 7
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CartPaymentMethodCell.self, forCellWithReuseIdentifier: CartPaymentMethodCell.defaultReuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var informationLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .ypBlack)
        
        let attrString = NSMutableAttributedString()
        let firstLineAttrText = NSMutableAttributedString(string: NSLocalizedString("Совершая покупку, вы соглашаетесь с условиями\n", comment: ""))
        let secondLineAttrText = NSMutableAttributedString(string: NSLocalizedString("Пользовательского соглашения", comment: ""))
        let range = NSRange(location: 0, length: secondLineAttrText.length)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        secondLineAttrText.addAttribute(.link, value: K.Links.userLicenseLink, range: range)
        attrString.append(firstLineAttrText)
        attrString.append(secondLineAttrText)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        
        label.attributedText = attrString
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
        
        return label
    }()
    
    private lazy var proceedButton: CustomActionButton = {
        let button = CustomActionButton(title: NSLocalizedString("К оплате", comment: ""), appearance: .confirm)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .ypLightGrey
        
        stackView.layer.cornerRadius = 12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        stackView.addArrangedSubview(informationLabel)
        stackView.addArrangedSubview(proceedButton)
        
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: CartPaymentMethodViewModel, dataSource: PaymentMethodDSManagerProtocol) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("Выберите способ оплаты", comment: "")
        setupConstraints()
        createDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func createDataSource() {
        dataSource.createDataSource(with: collectionView, with: viewModel.getPaymentMethods())
    }
}

// MARK: - Ext @objc
@objc private extension CartPaymentMethodViewController {
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        onTapUserLicense?()
    }
    
    func payTapped() {
        onProceed?()
    }
}

extension CartPaymentMethodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interitemSpacing = 5.0
        return CGSize(width: collectionView.bounds.width * GridItemSize.half.rawValue - interitemSpacing, height: 46)
    }
}

// MARK: - Ext Constraints
extension CartPaymentMethodViewController {
    func setupConstraints() {
        setupInfoStackViewView()
        setupCollectionView()
        
    }
    
    func setupInfoStackViewView() {
        view.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: infoStackView.topAnchor)
        ])
    }
}
