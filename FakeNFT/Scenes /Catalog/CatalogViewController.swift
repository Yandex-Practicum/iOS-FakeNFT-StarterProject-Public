import UIKit
import Kingfisher

final class CatalogViewController: UIViewController {
        
    private var viewModel = CatalogViewModel()
    private var collectons: [NFTsCollectionModel] {
        viewModel.collections
    }
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.reloadData = self.tableView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    private func setupUI() {
        [tableView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setupNavBar() {
        let sortButtonImage = UIImage(systemName: "line.3.horizontal.decrease")
        let sortButton = UIBarButtonItem(image: sortButtonImage, style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc private func sortButtonTapped() {
        let allert = UIAlertController(title: "Cортировка", message: nil, preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: "По названию", style: .default) { _ in
            //ToDo
        }
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default) { _ in
            //ToDo
        }
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        allert.addAction(sortByName)
        allert.addAction(sortByCount)
        allert.addAction(cancel)
        
        present(allert, animated: true, completion: nil)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath) as? CatalogCell else { return UITableViewCell()}
        let collection = collectons[indexPath.row]
        if let imageURLString = collection.cover,
           let imageURL = URL(string: imageURLString.encodeURL) {
            cell.itemImageView.kf.setImage(with: imageURL)
        }
        cell.nameLabel.text = collection.nameAndNFTsCount
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        179
    }
}

extension String {
    var encodeURL: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeURL: String {
        return self.removingPercentEncoding!
    }
}
