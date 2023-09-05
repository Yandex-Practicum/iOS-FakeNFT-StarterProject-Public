import UIKit
protocol CartViewDelegate: AnyObject {
   func didTapPurchaseButton()
}

final class CartView: UIView {

    weak var delegate: CartViewDelegate?

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size15
        label.text = "3 NFT"
        label.textColor = .label
        label.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nftFullSumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.text = "5,34 ETH"
        label.textColor = UIColor.Universal.green
        label.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.tintColor = UIColor.Universal.white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.Universal.black?.cgColor
        button.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nftStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func purchaseButtonTapped() {
        delegate?.didTapPurchaseButton()
    }
    func setNftCount(text: String) {
        nftCountLabel.text = text
    }
    func setSumNft(text: String) {
        nftFullSumLabel.text = text
    }
    private func addSubviews() {
        addSubview(nftStackView)
        nftStackView.addArrangedSubview(nftCountLabel)
        nftStackView.addArrangedSubview(nftFullSumLabel)
        addSubview(purchaseButton)
    }

   private func setConstraints() {
        NSLayoutConstraint.activate([
            nftStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            purchaseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            purchaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            purchaseButton.widthAnchor.constraint(equalToConstant: 240),
            purchaseButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
