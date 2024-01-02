
import UIKit

protocol MyNFTViewControllerProtocol: AnyObject, LoadingView {
    var presenter: MyNFTPresenterProtocol? { get }
    func updateUI()
    func showCap()
    func hiddenCap()
}

final class MyNFTViewController: UITableViewController, MyNFTViewControllerProtocol {
    
    var presenter: MyNFTPresenterProtocol?
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "chevron.backward")
        button.action = #selector(goBack)
        button.target = self
        return button
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sortImage")?.withTintColor(UIColor.ypBlack, renderingMode: .alwaysOriginal)
        button.action = #selector(sortButtonDidTapped)
        button.target = self
        return button
    }()
    
    private lazy var capLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("myNFT.CapLabelText", comment: "")
        label.font = UIFont(name: "SFProText-Bold", size: 17);
        label.isHidden = true
        return label
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(presenter: MyNFTPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        view.backgroundColor = UIColor.ypWhite
        
        tableView.separatorStyle = .none
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.cellID)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.ypBlack
        navigationItem.title = NSLocalizedString("myNFT.navigationItem.title", comment: "")
        navigationItem.rightBarButtonItem = sortButton
        
        addSubviews()
        
        presenter?.viewDidLoad()
    }
    
    func showCap() {
        capLabel.isHidden = false
    }
    
    func hiddenCap() {
        capLabel.isHidden = true
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.nfts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.cellID, for: indexPath) as? MyNFTCell
        else { return UITableViewCell()}
        guard let nft = presenter?.nfts[indexPath.row] else { return UITableViewCell()}
        let presenter = MyNFTCellPresenter(view: cell,
                                            nft: nft,
                                            likedNfts: presenter?.likedNft ?? Set(),
                                            servicesAssembly: presenter?.servicesAssembly )
        presenter.delegate = self
        cell.presenter = presenter
        cell.configereCell()
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.viewWillDisappear()
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonDidTapped() {
        let alertController = UIAlertController(
            title: NSLocalizedString("sort", comment: ""),
            message: "",
            preferredStyle: .actionSheet)
        let actionByPrice = UIAlertAction(
            title: NSLocalizedString("byPrice", comment: ""),
            style: .default) { [weak self] _ in
                self?.presenter?.sortNFT(typeSorting: .byPrice)
            }
        let actionByRating = UIAlertAction(
            title: NSLocalizedString("byRating", comment: ""),
            style: .default) { [weak self] _ in
                self?.presenter?.sortNFT(typeSorting: .byRating)
            }
        let actionByName = UIAlertAction(
            title: NSLocalizedString("byName", comment: ""),
            style: .default) { [weak self] _ in
                self?.presenter?.sortNFT(typeSorting: .byName)
            }
        let сloseAction = UIAlertAction(
            title: NSLocalizedString("close", comment: ""),
            style: .cancel,
            handler: nil)
        
        alertController.addAction(actionByPrice)
        alertController.addAction(actionByRating)
        alertController.addAction(actionByName)
        alertController.addAction(сloseAction)
        present(alertController, animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(capLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            capLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            capLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
