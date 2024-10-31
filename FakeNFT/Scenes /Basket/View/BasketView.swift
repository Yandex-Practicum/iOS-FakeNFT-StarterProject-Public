import UIKit
import ProgressHUD

protocol BasketViewProtocol: AnyObject {
    func updateNfts(_ nfts: [NftModel])
    func showEmptyLabel(_ show: Bool)
    func changeSumText(totalAmount: Int, totalPrice: Float)
    func showHud()
    func removeHud()
    func setDelegate(_ delegate: BasketViewController)
}

final class BasketView: UIView, BasketViewProtocol {
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        return button
    }()
    
    private lazy var sumView: SumView = {
        let sum = SumView()
        return sum
    }()
    
    private lazy var nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "Корзина пуста"
        label.isHidden = true
        label.textColor = .yaBlackLight
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        sortButton.tintColor = .closeButton
        [sumView, sortButton, nftsTableView, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -17),
            sortButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            sumView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            sumView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            sumView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            sumView.heightAnchor.constraint(equalToConstant: 76),
            
            nftsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 54),
            nftsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: sumView.topAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func updateNfts(_ nfts: [NftModel]) {
        nftsTableView.reloadData()
    }
    
    func showEmptyLabel(_ show: Bool) {
        emptyLabel.isHidden = !show
        nftsTableView.isHidden = show
        sortButton.isHidden = show
        sumView.isHidden = show
    }
    
    func changeSumText(totalAmount: Int, totalPrice: Float) {
        let roundedTotalPrice = Float(round(100 * totalPrice) / 100)
        let amountStr = "\(totalAmount) NFT"
        let priceStr = "\(roundedTotalPrice) ETH"
        sumView.changeText(totalAmountStr: amountStr, totalPriceStr: priceStr)
    }
    
    func showHud() {
        ProgressHUD.show()
    }
    
    func removeHud() {
        ProgressHUD.dismiss()
    }
    
    func setDelegate(_ delegate: BasketViewController) {
        nftsTableView.delegate = delegate
        nftsTableView.dataSource = delegate
        nftsTableView.register(BasketNFTCell.self)
        sortButton.addTarget(delegate, action: #selector(delegate.didTapSortButton), for: .touchUpInside)
        sumView.delegate = delegate
    }
}
