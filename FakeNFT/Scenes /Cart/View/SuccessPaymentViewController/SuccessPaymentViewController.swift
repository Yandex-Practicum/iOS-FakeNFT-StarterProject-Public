import UIKit

final class SuccessPaymentViewController: UIViewController {
    
    //MARK: - Computed properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "successImage")
        imageView.frame = CGRect(x: 0, y: 0, width: 278, height: 278)
        
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .nftBlack
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var successButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.nftWhite, for: .normal)
        button.backgroundColor = .nftBlack
        button.layer.cornerRadius = 16
        button.addTarget(nil, action: #selector(successButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .nftWhite
        
        addSubviews()
        constraintsSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Private methods
    
    private func addSubviews() {
        [imageView,
         successLabel,
         successButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            successButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            successButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            successButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            successButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    //MARK: - Handlers
    
    @objc func successButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
