import UIKit

final class PaymentPanelView: UIView {
    
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
        // добавить подобные строки в локализацию
        button.setTitle(NSLocalizedString("К оплате", comment: ""),
                        for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(UIColor.background,
                             for: .normal)
        button.backgroundColor = UIColor.segmentActive
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(count: Int, price: Double) {
        countLabel.text = "\(count) NFT"
        priceLabel.text = "\(String(format: "%.2f", price)) ETH"
    }
    
    private func initialize() {
        backgroundColor = UIColor.segmentInactive
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 12
        
        [payButton,
         countLabel,
         priceLabel].forEach {
            addSubview($0)
        }
        
        payButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(priceLabel.snp.trailing).offset(24)
        }
        
        countLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(countLabel.snp.bottom).offset(2)
        }
    }
}

