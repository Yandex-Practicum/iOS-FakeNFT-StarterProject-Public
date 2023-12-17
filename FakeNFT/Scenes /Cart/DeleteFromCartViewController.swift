import UIKit

final class DeleteFromCartViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    private let itemImage: UIImage
    private let itemIndex: Int
    weak var delegate: DeleteFromCartViewControllerDelegate?
    
    // MARK: - Computed Properties
    
    private lazy var blurView: UIView = {
        let view = UIView()
        let dimmedView = UIView()
        let blurEffect = UIBlurEffect(style: .regular)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        customBlurEffectView.frame = self.view.bounds
        dimmedView.backgroundColor = .NFTWhite?.withAlphaComponent(0.1)
        dimmedView.frame = self.view.bounds
        view.addSubview(customBlurEffectView)
        view.addSubview(dimmedView)
        
        return view
    }()
    
    private lazy var layerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = itemImage
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .NFTBlack
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.NFTRedUniversal, for: .normal)
        button.backgroundColor = .NFTBlack
        button.layer.cornerRadius = 12
        button.addTarget(nil, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.NFTWhite, for: .normal)
        button.backgroundColor = .NFTBlack
        button.layer.cornerRadius = 12
        button.addTarget(nil, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(itemImage: UIImage, itemIndex: Int) {
        self.itemImage = itemImage
        self.itemIndex = itemIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        constraintsSetup()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        view.addSubview(layerView)
        
        [deleteImageView,
         deleteLabel,
         stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            layerView.addSubview($0)
        }
        
        [deleteButton,
         cancelButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            layerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            layerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -56),
            layerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            layerView.heightAnchor.constraint(equalToConstant: 220),
            
            deleteImageView.topAnchor.constraint(equalTo: layerView.topAnchor),
            deleteImageView.centerXAnchor.constraint(equalTo: layerView.centerXAnchor),
            deleteImageView.heightAnchor.constraint(equalToConstant: 108),
            deleteImageView.widthAnchor.constraint(equalToConstant: 108),
            
            deleteLabel.topAnchor.constraint(equalTo: deleteImageView.bottomAnchor, constant: 12),
            deleteLabel.centerXAnchor.constraint(equalTo: layerView.centerXAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: layerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layerView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Handlers
    
    @objc func deleteButtonDidTap() {
        dismiss(animated: true)
        delegate?.deleteItemFromCart(for: itemIndex)
        delegate?.showTabBar()
    }
    
    @objc func cancelButtonDidTap() {
        dismiss(animated: true)
        delegate?.showTabBar()
    }
}
