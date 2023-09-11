import UIKit

final class CartViewController: UIViewController {
    
    enum Route: String {
        case pay
        case paymentChoice
        case purchasResult
    }
    
    var viewModel: CartViewModelProtocol?
    var router: CartRouter?
    
    private var indexDelete: Int?
    
    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .systemBackground
        addViews()
        setNavBar()
        setupUI()
        setupButtonPaymentView()
        viewModel?.didLoad()
        configure(viewModel: viewModel as! CartViewModel)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var plugLabel: UILabel = {
        let plugLabel = UILabel()
        return plugLabel
    }()
    
    private lazy var plugImage: UIImageView = {
        let plugImage = UIImageView()
        return plugImage
    }()
    
    private lazy var sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
        return sortButton
    }()
    
    private lazy var buttonPaymentView: UIView = {
        let buttonPaymentView = UIView()
        buttonPaymentView.backgroundColor = .ypLightGrey
        buttonPaymentView.layer.cornerRadius = 12
        buttonPaymentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return buttonPaymentView
    }()
    
    private lazy var countNFTLabel: UILabel = {
        let countNFTLabel = UILabel()
        countNFTLabel.text = "0 NFT"
        
        return countNFTLabel
    }()
    
    private lazy var totalCoastNFTLabel: UILabel = {
        let totalCoastNFTLabel = UILabel()
        totalCoastNFTLabel.text = "0,0"
        totalCoastNFTLabel.textColor = .ypGreen
        totalCoastNFTLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return totalCoastNFTLabel
    }()
    
    private lazy var payButton: UIButton = {
        let payButton = UIButton()
        payButton.setTitle("К оплате", for: .normal)
        payButton.titleLabel?.font = .bodyBold
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .ypBlack
        payButton.layer.cornerRadius = 16
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return payButton
    }()
    
    private lazy var deleteView: UIVisualEffectView = {
        let deleteView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        deleteView.frame = self.view.bounds
        deleteView.isHidden = true
        return deleteView
    }()
    
    private lazy var deletingImage: UIImageView = {
        let deletingImage = UIImageView()
        deletingImage.image = UIImage(named: "mockImageNft")
        deletingImage.isHidden = true
        return deletingImage
    }()
    
    private lazy var deleteLabel: UILabel = {
        let deleteLabel = UILabel()
        deleteLabel.text = "Вы уверены, что хотите удалить объект из корзины?"
        deleteLabel.font = UIFont.systemFont(ofSize: 13)
        deleteLabel.textAlignment = .center
        deleteLabel.isHidden = true
        return deleteLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.backgroundColor = .ypBlack
        deleteButton.layer.cornerRadius = 12
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(method), for: .touchUpInside)
        return deleteButton
        
    }()
    
    private lazy var returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.setTitle("Вернуться", for: .normal)
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.backgroundColor = .ypBlack
        returnButton.layer.cornerRadius = 12
        returnButton.isHidden = true
        returnButton.addTarget(self, action: #selector(method), for: .touchUpInside)
        return returnButton
    }()
    
    private func addViews(){
        [tableView, plugImage, plugLabel, sortButton, buttonPaymentView, countNFTLabel, totalCoastNFTLabel, payButton, deleteView, deletingImage, deleteLabel, deleteButton, returnButton].forEach(view.setupView(_:))
    }
    
    private func setNavBar() {
        let sortButton = UIBarButtonItem(customView: sortButton)
        self.navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupButtonPaymentView(){
        buttonPaymentView.addSubview(countNFTLabel)
        buttonPaymentView.addSubview(totalCoastNFTLabel)
        buttonPaymentView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            countNFTLabel.leadingAnchor.constraint(equalTo: buttonPaymentView.leadingAnchor, constant: 16),
            countNFTLabel.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 16),
            totalCoastNFTLabel.topAnchor.constraint(equalTo: countNFTLabel.bottomAnchor, constant: 1),
            totalCoastNFTLabel.leadingAnchor.constraint(equalTo: buttonPaymentView.leadingAnchor, constant: 16),
            payButton.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: buttonPaymentView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: buttonPaymentView.bottomAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonPaymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonPaymentView.heightAnchor.constraint(equalToConstant: 76),
            buttonPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc private func didTapPayButton() {
                let vc = PaymentChoiceViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
        
//        router?.perform(.pay, from: self)
        
    }
    
    private func configure(viewModel: CartViewModel) {
        self.viewModel = viewModel
        viewModel.$nfts.bind { [weak self] _ in
            self?.countNFTLabel.text = "\(viewModel.nftInfo.count)" + " " + "NFT"
            self?.totalCoastNFTLabel.text = "\(viewModel.nftInfo.price)" + " " + "ETH"
            self?.tableView.reloadData()
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.nfts.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        guard let model = viewModel?.nfts[indexPath.row] else { return cell}
        cell.configureCell(model: model, cell: cell)
        cell.indexCell = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension CartViewController: NFTTableViewCellDelegate {
    func showDeleteView(index: Int) {
        print(index)
        print("tap tap")
    }
    
    
}
