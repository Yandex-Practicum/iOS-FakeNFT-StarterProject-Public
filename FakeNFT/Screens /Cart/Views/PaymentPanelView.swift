import UIKit

final class PaymentPanelView: UIView {
    
    // MARK: - UI Elements
    
    private let countLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption1
        label.textColor = UIColor.segmentActive
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textGreen
        
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("PaymentPanel", comment: ""),
                        for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(UIColor.background,
                             for: .normal)
        button.backgroundColor = UIColor.segmentActive
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func set(count: Int, price: Double) {
        countLabel.text = "\(count) NFT"
        priceLabel.text = "\(String(format: "%.2f", price)) ETH"
    }
    
    // MARK: - Private Methods
    
    private func initialize() {
        backgroundColor = UIColor.segmentInactive
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 12
        
        [payButton,
         countLabel,
         priceLabel].forEach {
            addSubview($0)
        }
        
        setupPayButton()
        setupCountLabel()
        setupPriceLabel()
    }
    
    private func setupPayButton() {
        payButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(priceLabel.snp.trailing).offset(24)
        }
    }
    
    private func setupCountLabel() {
        countLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
    }
    
    private func setupPriceLabel() {
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(countLabel.snp.bottom).offset(2)
        }
    }
}

