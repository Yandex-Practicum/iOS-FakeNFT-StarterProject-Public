import UIKit
import Kingfisher

final class CatalogViewController: UIViewController {
        
    private var viewModel = CatalogViewModel()
    private var collectons: [NFTsCollectionNetworkModel] {
        viewModel.collections
    }
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        tableView.backgroundColor = .background
        tableView.separatorColor = .background
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavBar() {
        let sortButtonImage = UIImage(named: "sortButton")
        let sortButton = UIBarButtonItem(image: sortButtonImage, style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        sortButton.tintColor = .black
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionVC = CollectionViewController(viewModel: CollectionViewModel(collection: collectons[indexPath.row]))
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
}

extension String {
    var encodeURL: String {
        if let encodedString = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            return encodedString
        } else {
            return "encode error!"
        }
    }
    var decodeURL: String {
        if let decodedString =  self.removingPercentEncoding {
            return decodedString
        } else {
            return "decode error!"
        }
    }
}
