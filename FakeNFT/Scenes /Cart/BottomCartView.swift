import UIKit

class BottomCartView: UIView{
    
    var nftCount: Int = 0 {
        didSet {
            countLabel.text = "\(nftCount) NFT"
        }
    }
    var totalSum: Float = 0 {
        didSet {
            totalLabel.text = "\(totalSum) ETH"
        }
    }
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .segmentActive
        return label
    }()
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .totalCartColor
        return label
    }()
    let cartButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("cart.ready", comment: ""), for: .normal)
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    private func setupUI(){
        backgroundColor = .segmentInactive
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 2
        vStack.addArrangedSubview(countLabel)
        vStack.addArrangedSubview(totalLabel)
        cartButton.addTarget(self, action: #selector(cartButtonDidTap), for: .touchUpInside)
        addSubviews(vStack,cartButton)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            cartButton.leadingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 24),
            cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cartButton.centerYAnchor.constraint(equalTo: vStack.centerYAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc private func cartButtonDidTap(){
        print("cartButtonDidTap")
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
