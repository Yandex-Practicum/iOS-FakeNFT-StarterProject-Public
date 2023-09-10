import UIKit

final class CheckoutFlowViewController: UIViewController {
    enum Flow {
        case failure
        case success
    }
    
    private var currentFlow: Flow
    
    init(currentFlow: Flow) {
        self.currentFlow = currentFlow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "successFlow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let failureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "failureFlow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size22
        label.textColor = UIColor.Universal.black
        label.textAlignment = .center
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let failureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size22
        label.textColor = UIColor.Universal.black
        label.textAlignment = .center
        label.text = "Упс! Что-то пошло не так :(\n Попробуйте ещё раз!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var successButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться в каталог", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.Universal.black?.cgColor
        button.addTarget(self,
                         action: #selector(successButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var failureButton: UIButton = {
       let button = UIButton()
        button.setTitle("Попробовать ещё раз", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.Universal.black?.cgColor
        button.addTarget(self, action: #selector(failureButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFlow()
    }
    
    @objc func failureButtonTapped() {
        dismiss(animated: true)
    }
                         
    @objc func successButtonTapped() {
        // TODO: Make a transition into Catalog
    }
    
    private func configureFlow() {
        switch currentFlow {
        case .failure: setupFailureView()
        case .success: setupSuccessView()
        }
    }
    
    private func setupSuccessView() {
        view.backgroundColor = .white
        view.addSubview(successImageView)
        view.addSubview(successLabel)
        view.addSubview(successButton)
        
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            successButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            successButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            successButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            successButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupFailureView() {
        view.backgroundColor = .white
        view.addSubview(failureImageView)
        view.addSubview(failureLabel)
        view.addSubview(failureButton)
        
        NSLayoutConstraint.activate([
            failureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            failureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 187),
            failureImageView.widthAnchor.constraint(equalToConstant: 287),
            failureImageView.heightAnchor.constraint(equalToConstant: 287),
            
            failureLabel.topAnchor.constraint(equalTo: failureImageView.bottomAnchor, constant: 20),
            failureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            failureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            failureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            failureButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            failureButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
