import UIKit

final class MyNFTsViewController: UIViewController & MyNFTsViewControllerProtocol {
    // MARK: - Public properties
    
    var presenter: MyNFTsViewDelegate?
    
    // MARK: - Private properties
    
    private let tableView = UITableView()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = NSLocalizedString("nft.missing", comment: "")
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        presenter?.viewDidLoad()
        configureNavigationController()
        tableViewConfigure()
        addingUIElements()
        layoutConfigure()
        checkPlaceholderLabelVisibility()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.callback?()
    }
    
    // MARK: - MyNFTsViewControllerProtocol
    
    func updateTable() {
        checkPlaceholderLabelVisibility()
        tableView.reloadData()
    }
    
    
    func showNetworkErrorAlert(with error: Error) {
        if presentedViewController is UIAlertController { return }
        
        let alertMessage = ("\(NSLocalizedString("nft.error.message", comment: ""))\n\(error)")
        
        let alert = UIAlertController(
            title: NSLocalizedString("nft.error.title", comment: ""),
            message: alertMessage,
            preferredStyle: .alert)
        
        let repeatAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.retryButton", comment: ""),
            style: .default
        ) { _ in
            self.presenter?.viewDidLoad()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.cancelButton", comment: ""),
            style: .cancel
        )
        alert.addAction(repeatAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        [placeholderLabel, tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNavigationController() {
        title = NSLocalizedString("profile.myNFTs", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.ypBlack
        ]
        
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: symbolConfiguration) ?? UIImage()
        let backButton = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        
        let sortButton = UIBarButtonItem(
            image: .sortButton,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func checkPlaceholderLabelVisibility() {
        placeholderLabel.isHidden = presenter?.missingNFCLabelIsNeedToHide ?? true
    }
    
    private func tableViewConfigure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNFTCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("sort.title", comment: ""),
            preferredStyle: .actionSheet
        )
        
        let priceSortAction = UIAlertAction(
            title: NSLocalizedString("sort.byPrice", comment: ""),
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.currentSortOption = .byPrice
        }
        let ratingSortAction = UIAlertAction(
            title: NSLocalizedString("sort.byRating", comment: ""),
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.currentSortOption = .byRating
        }
        let nameSortAction = UIAlertAction(
            title: NSLocalizedString("sort.byName", comment: ""),
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.currentSortOption = .byName
        }
        let closeAction = UIAlertAction(
            title: NSLocalizedString("sort.close", comment: ""),
            style: .cancel
        )
        alert.addAction(priceSortAction)
        alert.addAction(ratingSortAction)
        alert.addAction(nameSortAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyNFTsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.counterOfNFTs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return UITableViewCell() }
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        let model = presenter.getModelFor(indexPath: indexPath)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
