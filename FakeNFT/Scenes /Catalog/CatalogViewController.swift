import UIKit
import Kingfisher

final class CatalogViewController: UIViewController {
        
    private var viewModel = CatalogViewModel()
    private var collectons: [NFTsCollectionNetworkModel] {
        viewModel.collections
    }
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogTabelViewCell.self, forCellReuseIdentifier: CatalogTabelViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        tableView.backgroundColor = .white
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
        setupNavBar()
        
        viewModel.loadingStarted = self.loadIndicatorStartAnimating
        viewModel.loadingFinished = self.loadIndicatorStopAnimating
        viewModel.updateData()
    }
    
    private func addSubviews() {
        [tableView, loadIndicator].forEach {
            view.addSubview($0)
        }
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
        let sortByName = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel.sortByName()
        }
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.viewModel.sortByNFTsCount()
        }
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        allert.addAction(sortByName)
        allert.addAction(sortByCount)
        allert.addAction(cancel)
        
        present(allert, animated: true, completion: nil)
    }
    
    private func loadIndicatorStartAnimating() {
        loadIndicator.startAnimating()
    }
    
    private func loadIndicatorStopAnimating() {
        loadIndicator.stopAnimating()
    }
}

//MARK: -UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTabelViewCell.reuseIdentifier, for: indexPath) as? CatalogTabelViewCell else { return UITableViewCell()}
        let collection = collectons[indexPath.row]
        if let imageURLString = collection.cover,
           let imageURL = URL(string: imageURLString.encodeURL) {
            cell.itemImageView.kf.setImage(with: imageURL)
        }
        cell.nameLabel.text = collection.nameAndNFTsCount
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: -UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        179
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionVC = CollectionViewController(viewModel: CollectionViewModel(collection: collectons[indexPath.row]))
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
}
