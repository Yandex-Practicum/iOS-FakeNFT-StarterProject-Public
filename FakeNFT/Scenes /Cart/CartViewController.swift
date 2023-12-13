import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    private let mockNFTArray: [CartNFTModel] = CartMockData.mockNFT
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Computed Properties
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .NFTBlack
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIndentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .NFTWhite
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .NFTWhite
        
        addSubviews()
        constraintsSetup()
        navBarSetup()
    }
    
    // MARK: - Private properties
    
    private func addSubviews() {
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func navBarSetup() {
        if let navBar = navigationController?.navigationBar {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
            sortButton.addTarget(nil, action: #selector(sortButtonDidTap), for: .touchUpInside)
            
            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }
    
    // MARK: - Obj-C functions
    
    @objc func sortButtonDidTap() {
        //TODO: add code to sort items in cart
    }
}

    // MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockNFTArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIndentifier) as? CartTableViewCell else { return UITableViewCell() }
        
        let nft = mockNFTArray[indexPath.row]
        cell.configureCell(with: nft)
        
        return cell
    }
}

    // MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
