import UIKit

final class ConfirmView: UIView {
    
    weak var delegate: CartPurchaseDelegate?
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size13
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var linkAgreementButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пользовательское соглашение", for: .normal)
        button.titleLabel?.font = UIFont.Regular.size13
        button.setTitleColor(UIColor.Universal.blue, for: .normal)
        button.addTarget(self, action: #selector(agreementLinkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var confirmPurchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.black.cgColor
        button.addTarget(self,
                         action: #selector(confirmButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(agreementLabel)
        addSubview(linkAgreementButton)
        addSubview(confirmPurchaseButton)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            agreementLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            agreementLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            agreementLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -152),

            linkAgreementButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            linkAgreementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            linkAgreementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -157),
            linkAgreementButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -126),

            confirmPurchaseButton.topAnchor.constraint(equalTo: linkAgreementButton.bottomAnchor, constant: 16),
            confirmPurchaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmPurchaseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            confirmPurchaseButton.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -12)
        ])
    }

    @objc func confirmButtonTapped() {
        // TODO: Transition on confirm page
    }
    
    @objc func agreementLinkTapped() {
        delegate?.didTappedAgreementLink()
    }
}
