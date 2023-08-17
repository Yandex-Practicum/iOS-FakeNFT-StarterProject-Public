import UIKit

public final class CartRemoveNftViewController: UIViewController {
    public enum RemoveNftFlow {
        case remove
        case cancel
    }

    private enum Constants {
        static let nftImageViewCornerRadius: CGFloat = 12
        static let nftImageViewTopInset: CGFloat = 244
        static let nftImageViewSideInset: CGFloat = 133

        static let removeNftLabelTopInset: CGFloat = 12
        static let removeNftLabelSideInset: CGFloat = 97

        static let buttonsTopInset: CGFloat = 20
        static let buttonsSideInset: CGFloat = 56
        static let buttonsSpacing: CGFloat = 8
        static let buttonsHeight: CGFloat = 44
    }

    var onChoosingRemoveNft: ActionCallback<RemoveNftFlow>?

    private let blurredEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.nftImageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let removeNftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CART_REMOVE_NFT_REMOVE_LABEL_TEXT".localized
        label.textAlignment = .center
        label.font = .getFont(style: .regular, size: 13)
        label.textColor = .appBlack
        label.numberOfLines = 0
        return label
    }()

    private lazy var removeNftButton: AppButton = {
        let button = AppButton(type: .nftCartRemove, title: "CART_REMOVE_NFT_REMOVE_BUTTON_TITLE".localized)
        button.addTarget(self, action: #selector(self.didTapRemoveNftButton), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: AppButton = {
        let button = AppButton(type: .nftCartCancel, title: "CART_REMOVE_NFT_CANCEL_BUTTON_TITLE".localized)
        button.addTarget(self, action: #selector(self.didTapCancelButton), for: .touchUpInside)
        return button
    }()

    init(nftImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.nftImageView.image = nftImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

private extension CartRemoveNftViewController {
    func configure() {
        self.view.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.blurredEffectView)
        self.view.addSubview(self.nftImageView)
        self.view.addSubview(self.removeNftLabel)
        self.view.addSubview(self.removeNftButton)
        self.view.addSubview(self.cancelButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.blurredEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurredEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurredEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.blurredEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.nftImageView.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: Constants.nftImageViewTopInset
            ),
            self.nftImageView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.nftImageViewSideInset
            ),
            self.nftImageView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.nftImageViewSideInset
            ),
            self.nftImageView.heightAnchor.constraint(equalTo: self.nftImageView.widthAnchor),

            self.removeNftLabel.topAnchor.constraint(
                equalTo: self.nftImageView.bottomAnchor,
                constant: Constants.removeNftLabelTopInset
            ),
            self.removeNftLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.removeNftLabelSideInset
            ),
            self.removeNftLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.removeNftLabelSideInset
            ),

            self.removeNftButton.topAnchor.constraint(
                equalTo: self.removeNftLabel.bottomAnchor,
                constant: Constants.buttonsTopInset
            ),
            self.removeNftButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Constants.buttonsSideInset
            ),
            self.removeNftButton.trailingAnchor.constraint(
                equalTo: self.cancelButton.leadingAnchor,
                constant: -Constants.buttonsSpacing
            ),
            self.removeNftButton.widthAnchor.constraint(equalTo: self.cancelButton.widthAnchor),
            self.removeNftButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),

            self.cancelButton.topAnchor.constraint(equalTo: self.removeNftButton.topAnchor),
            self.cancelButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Constants.buttonsSideInset
            ),
            self.cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
        ])
    }
}

// MARK: - Actions
private extension CartRemoveNftViewController {
    @objc
    func didTapRemoveNftButton() {
        self.onChoosingRemoveNft?(.remove)
    }

    @objc
    func didTapCancelButton() {
        self.onChoosingRemoveNft?(.cancel)
    }
}
