import UIKit

protocol RemoveNFTView: AnyObject {
    func updateImage(with url: URL?)
}

protocol RemoveNFTViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(_ model: NftModel)
}

final class RemoveNFTViewController: UIViewController, RemoveNFTView {
    
    weak var delegate: RemoveNFTViewControllerDelegate?
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .yaBlackLight
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var cancelButton: Button = {
        let button = Button(title: "Вернуться")
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: Button = {
        let button = Button(title: "Удалить")
            .titleColor(.red)
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    private var model: NftModel?
    
    init(nftModel: NftModel, delegate: RemoveNFTViewControllerDelegate) {
        self.model = nftModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
            configure(with: model)
        }
        
        setupView()
    }
    
    func updateImage(with url: URL?) {
        if let url = url {
            nftImageView.kf.setImage(with: url)
        }
    }
    
    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func didTapConfirmButton() {
        guard let model else { return }
        delegate?.didTapConfirmButton(model)
    }
}

private extension RemoveNFTViewController {
    func setupView() {
        [nftImageView, alertLabel, buttonsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(blurView)
        view.addSubview(nftImageView)
        view.addSubview(alertLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(confirmButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: alertLabel.topAnchor, constant: -12),
            nftImageView.widthAnchor.constraint(equalToConstant: BasketNFTCell.Constants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: BasketNFTCell.Constants.imageSize),
            
            alertLabel.widthAnchor.constraint(equalToConstant: 180),
            alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 262),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension RemoveNFTViewController {
    private func configure(with model: NftModel) {
        self.model = model
        if
            let image = model.images.first,
            let url = URL(string: image) {
            updateImage(with: url)
        }
    }
}
