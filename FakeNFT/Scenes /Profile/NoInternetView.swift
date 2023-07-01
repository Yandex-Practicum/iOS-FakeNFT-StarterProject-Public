import UIKit

final class NoInternetView: UIView {
    
    //MARK: - Layout elements
    private lazy var noInternetLabel: UILabel = {
        let noInternetLabel = UILabel()
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        noInternetLabel.text = "Нет интернета"
        noInternetLabel.font = UIFont.boldSystemFont(ofSize: 17)
        noInternetLabel.textColor = .black
        return noInternetLabel
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addEmptyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout methods
    func addEmptyLabel() {
        addSubview(noInternetLabel)
        
        NSLayoutConstraint.activate([
            noInternetLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noInternetLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

    }
}
