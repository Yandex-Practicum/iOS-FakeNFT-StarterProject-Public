import UIKit

final class PaymentSuccessViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .paymentSuccess)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var paymentResultLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Payment.successText
        label.textColor = UIColor(resource: .blackDayNight)
        label.font = .headline3
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var paymentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(paymentResultLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var backToCatalogButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(L10n.Payment.backToCatalogueText, for: .normal)
        button.setTitleColor(UIColor(resource: .whiteDayNight), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.backgroundColor = UIColor(resource: .blackDayNight)
        button.addTarget(self, action: #selector(tapBackToCatalogButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDayNight)
        createSubviews()
    }

    private func createSubviews() {
        view.addSubview(paymentStackView)
        view.addSubview(backToCatalogButton)
        NSLayoutConstraint.activate([
            paymentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            paymentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            paymentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backToCatalogButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc
    private func tapBackToCatalogButton() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.selectedIndex = 0
        present(tabBarController, animated: true)
    }
}
