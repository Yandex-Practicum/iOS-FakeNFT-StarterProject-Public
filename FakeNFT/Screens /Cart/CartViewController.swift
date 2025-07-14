import SnapKit
import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CartPresenterProtocol
    private var cards = [CartItemModel]()
    
    // MARK: - UI Elements
    
    private lazy var paymentPanel = PaymentPanelView()
    private lazy var stubView = CartStubView(text: NSLocalizedString("Cart.empty", comment: ""))
    
    private var progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive
        
        return progress
    }()
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartItemCell.self,
                           forCellReuseIdentifier: CartItemCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(
            top: 20,
            left: 0,
            bottom: 0,
            right: 0
        )
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.setup()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = UIColor.background
        
        setupProgressHud()
    }
    
    private func setupViews() {
        [nftTableView,
         paymentPanel].forEach{
            view.addSubview($0)
        }
        
        setupPaymentPanel()
        setupNavBar()
        setupTableView()
    }
    
    private func setupProgressHud() {
        view.addSubview(progressHud)
        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupPaymentPanel() {
        paymentPanel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(76)
        }
    }
    
    private func setupStubView() {
        view.addSubview(stubView)
        
        stubView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        filterButton.tintColor = UIColor.segmentActive
        navigationItem.setRightBarButton(filterButton, animated: false)
    }
    
    private func setupTableView() {
        nftTableView.dataSource = self
        nftTableView.delegate = self
        
        nftTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func hideMainViews() {
        [nftTableView, paymentPanel].forEach {
            $0.isHidden = true
        }
        navigationItem.setRightBarButton(nil, animated: false)
    }
    
    private func showMainViews(with data: CartScreenModel) {
        if !nftTableView.isDescendant(of: view) {
            setupViews()
            paymentPanel.set(
                count: data.itemsCount,
                price: data.totalPrice
            )
        }
        if nftTableView.isHidden {
            [nftTableView, paymentPanel].forEach {
                $0.isHidden = false
            }
            setupNavBar()
            
            nftTableView.reloadData()
            stubView.isHidden = true
        }
    }
    
    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: NSLocalizedString("Sort.label", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let alertAction1 = UIAlertAction(
            title: NSLocalizedString("Sort.byPrice", comment: ""),
            style: .default) { _ in
                self.presenter.sort(by: .price)
            }
        
        let alertAction2 = UIAlertAction(
            title: NSLocalizedString("Sort.byRating", comment: ""),
            style: .default) { _ in
                self.presenter.sort(by: .rating)
            }
        
        let alertAction3 = UIAlertAction(
            title:NSLocalizedString("Sort.byName", comment: ""),
            style: .default) { _ in
                self.presenter.sort(by: .name)
            }
        
        let alertActionCancel = UIAlertAction(
            title: NSLocalizedString("Sort.dismiss", comment: ""),
            style: .cancel)
        
        [alertAction1,
         alertAction2,
         alertAction3,
         alertActionCancel].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier,
                                                 for: indexPath)
        guard let cell = cell as? CartItemCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: cards[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    
}

// MARK: - CartViewProtocol

extension CartViewController: CartViewProtocol {
    func update(with data: CartScreenModel) {
        self.cards = data.items
        if cards.isEmpty {
            showStubView()
        } else {
            showMainViews(with: data)
            nftTableView.reloadData()
        }
    }
    
    func showProgressHUD() {
        progressHud.startAnimating()
    }
    
    func hideProgressHUD() {
        progressHud.stopAnimating()
    }
    
    private func showStubView() {
        if !stubView.isDescendant(of: view) {
            setupStubView()
        }
        stubView.isHidden = false
        hideMainViews()
    }
}
