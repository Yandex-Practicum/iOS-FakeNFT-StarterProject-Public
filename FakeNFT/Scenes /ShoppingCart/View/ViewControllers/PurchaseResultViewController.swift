import UIKit

class PurchaseResultViewController: UIViewController {
    
    var purchaseWasCompleted: Bool
    
    init(purchaseWasCompleted: Bool) {
        self.purchaseWasCompleted = purchaseWasCompleted
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var resultButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться в каталог", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(paymentResultTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var centreImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "purchaseTrue")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var centreLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,/n поздравляем с покупкой!"
        label.font = .headline3
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupResults()
        setupButton()
        setupCentre()
        
    }
    
    func setupResults() {
        if purchaseWasCompleted == true {
            centreImage.image = UIImage(named: "purchaseTrue")
            centreLabel.text = "Успех! Оплата прошла,/n поздравляем с покупкой!"
            resultButton.setTitle("returnCatalog", for: .normal)
        } else {
            let alert = UIAlertController(title: "Упс! Что-то пошло не так :(", message: "Попробуйте ещё раз!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupCentre() {
        view.addSubview(centreImage)
        view.addSubview(centreLabel)
        
        NSLayoutConstraint.activate([
            centreImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            centreImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centreImage.heightAnchor.constraint(equalToConstant: 278),
            centreImage.widthAnchor.constraint(equalToConstant: 278),
            
            centreImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            centreImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centreImage.heightAnchor.constraint(equalToConstant: 278),
            centreImage.widthAnchor.constraint(equalToConstant: 278),
            
            centreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centreLabel.topAnchor.constraint(equalTo: centreImage.bottomAnchor, constant: 20),
            centreLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    func setupButton() {
        view.addSubview(resultButton)
        
        NSLayoutConstraint.activate([
            resultButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            resultButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func paymentResultTapped() {
        
        if let tabBarController = presentingViewController?.presentingViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
}
