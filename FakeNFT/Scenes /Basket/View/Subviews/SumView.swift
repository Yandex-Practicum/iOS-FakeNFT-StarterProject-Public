import UIKit

protocol SumViewDelegate: AnyObject {
    func didTapPayButton()
}

final class SumView: UIView {
    private lazy var button: Button = {
        let button = Button(title: "К оплате")
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return button
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .yaBlackLight
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .yaGreenUniversal
        return label
    }()
    
    weak var delegate: SumViewDelegate?
    var totalAmount: Int = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPayButton() {
        delegate?.didTapPayButton()
    }
}

extension SumView {
    func changeText(totalAmountStr: String, totalPriceStr: String) {
        countLabel.text = totalAmountStr
        priceLabel.text = totalPriceStr
    }
}

private extension SumView {
    func setupView() {
        backgroundColor = .yaLightGrayLight
        layer.cornerRadius = 16
        
        [button, labelsStack]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        addSubview(button)
        addSubview(labelsStack)
        labelsStack.addArrangedSubview(countLabel)
        labelsStack.addArrangedSubview(priceLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            button.leadingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: labelsStack.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
