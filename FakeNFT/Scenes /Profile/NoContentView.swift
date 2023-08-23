import UIKit

final class NoContentView: UIView {
    private let noContent: NoContent
    private lazy var noContentLabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = noContent.localizedString()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .appBlack
        return label
    }()
    
    init(frame: CGRect, noContent: NoContent){
        self.noContent = noContent
        super.init(frame: .zero)
        
        backgroundColor = .appWhite
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(noContentLabel)
        
        NSLayoutConstraint.activate([
            noContentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noContentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
