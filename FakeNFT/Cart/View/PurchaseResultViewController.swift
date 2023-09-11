import UIKit

final class PurchaseResultViewController: UIViewController {
    
    var completePurchase: Bool
    
    
    init(completePurchase: Bool) {
        self.completePurchase = completePurchase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
        updateFinalResult()
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.font = .bodyBold
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private func updateFinalResult() {
        if completePurchase {
            label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
            image.image = UIImage(named: "successfullPurchase")
            button.setTitle("Вернуться в каталог", for: .normal)
        } else {
            label.text = "Упс! Что-то пошло не так :( Попробуйте ещё раз!"
            image.image = UIImage(named: "unsuccessfullPurchase")
            button.setTitle("Вернуться в каталог", for: .normal)
        }
    }
    
    private func addView() {
        [image, label, button].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func didTapButton() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = firstScene.windows.first else { return }
        let window = firstWindow
        window.rootViewController = CatalogViewController()
    }
}
