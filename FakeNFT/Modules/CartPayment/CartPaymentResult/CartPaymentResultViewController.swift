import UIKit

public final class CartPaymentResultViewController: UIViewController {
    public enum ResultType {
        case success
        case failure
    }

    private enum Constants {
        static let resultImageViewInsets = UIEdgeInsets(top: 152, left: 48, bottom: 304, right: 48)
        static let resultLabelInsets = UIEdgeInsets(top: 20, left: 36, bottom: 0, right: 36)

        static let resultButtonInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        static let resultButtonHeight: CGFloat = 60
    }

    var onResultButtonAction: ActionCallback<Void>?

    private lazy var resultImageView: UIImageView = {
        let image: UIImage = self.resultType == .success ? .Cart.PaymentResult.success : .Cart.PaymentResult.failure
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let text = self.resultType == .success
            ? "CART_PAYMENT_RESULT_SUCCESS_LABEL_TEXT".localized
            : "CART_PAYMENT_RESULT_FAILURE_LABEL_TEXT".localized
        label.text = text
        label.font = .getFont(style: .bold, size: 22)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var resultButton: AppButton = {
        let title = self.resultType == .success
            ? "CART_PAYMENT_RESULT_SUCCESS_BUTTON_TITLE".localized
            : "CART_PAYMENT_RESULT_FAILURE_BUTTON_TITLE".localized

        let button = AppButton(type: .filled, title: title)
        button.addTarget(self, action: #selector(self.didTapResultButton), for: .touchUpInside)
        return button
    }()

    private let resultType: ResultType

    init(resultType: ResultType) {
        self.resultType = resultType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

private extension CartPaymentResultViewController {
    func configure() {
        self.view.backgroundColor = .appWhite
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.resultImageView)
        self.view.addSubview(self.resultLabel)
        self.view.addSubview(self.resultButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.resultImageView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.resultImageViewInsets.top
            ),
            self.resultImageView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.resultImageViewInsets.left
            ),
            self.resultImageView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.resultImageViewInsets.right
            ),
            self.resultImageView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.resultImageViewInsets.bottom
            ),

            self.resultLabel.topAnchor.constraint(
                equalTo: self.resultImageView.bottomAnchor,
                constant: Constants.resultLabelInsets.top
            ),
            self.resultLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.resultLabelInsets.left
            ),
            self.resultLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.resultLabelInsets.right
            ),

            self.resultButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.resultButtonInsets.left
            ),
            self.resultButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.resultButtonInsets.right
            ),
            self.resultButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.resultButtonInsets.bottom
            ),
            self.resultButton.heightAnchor.constraint(equalToConstant: Constants.resultButtonHeight)
        ])
    }
}

// MARK: - Actions
private extension CartPaymentResultViewController {
    @objc
    func didTapResultButton() {
        self.onResultButtonAction?(())
    }
}
