import UIKit

final class CartViewController: UIViewController {
    
    private var addedNFTs: [NFT] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTCell.self, forCellReuseIdentifier: NFTCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .bodyBold
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Элементы для нижней панели оплаты
    
    private let paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addedNFTs = MockCartData.nfts
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addedNFTs = MockCartData.nfts
        setupView()
    }
    
    private func setupView() {
        
        if addedNFTs.isEmpty {
            setupEmptyView()
        } else {
            emptyLabel.isHidden = true
            setupTableView()
            setupPaymentView()
        }
    }
    
    private func setupEmptyView() {
        emptyLabel.isHidden = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setupPaymentView() {
        // Добавляем элементы для нижней панели оплаты
        view.addSubview(paymentView)
        
        NSLayoutConstraint.activate([
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            paymentView.heightAnchor.constraint(equalToConstant: 76),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// Реализация UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedNFTs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTCell.reuseIdentifier, for: indexPath) as? NFTCell else {
            return UITableViewCell()
        }
        let nft = addedNFTs[indexPath.row]
        cell.backgroundColor = .white
        cell.configure(with: nft)
        return cell
    }
}

// Реализация UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 
    }
}
