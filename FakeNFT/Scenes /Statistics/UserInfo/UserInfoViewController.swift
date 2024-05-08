import Kingfisher
import UIKit

// MARK: - Protocol
protocol UserInfoViewProtocol: AnyObject, ErrorView, LoadingView {
    func displayUserInfo(with user: UserInfo)
}

final class UserInfoViewController: UIViewController {
   
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    private let presenter: UserInfoPresenterProtocol
    
    //MARK: - UI elements
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .systemBackground
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem =  UIBarButtonItem(customView: backButton)
        navBar.setItems([navItem], animated: false)
        
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .textColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textColor
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var openSiteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("UserInfo.openSite", comment: ""), for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.titleLabel?.font = .caption1
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.textColor.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapOpenSiteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var infoNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InfoNFTTableCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    init(presenter: UserInfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapOpenSiteButton() {
        if let url = presenter.user?.website {
            let request = URLRequest(url: url)
            let webViewVC = WebViewController(request: request)
            webViewVC.modalPresentationStyle = .fullScreen
            present(webViewVC, animated: true)
        }
    }
    
    //MARK: - Layout
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        view.addSubview(navigationBar)
        view.addSubview(stackView)
        stackView.addArrangedSubview(avatarImage)
        stackView.addArrangedSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(openSiteButton)
        view.addSubview(infoNFTTableView)
        infoNFTTableView.dataSource = self
        infoNFTTableView.delegate = self
        infoNFTTableView.reloadData()
    }
    
    private func setupConstraints() {
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            openSiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            openSiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            openSiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            openSiteButton.heightAnchor.constraint(equalToConstant: 40),
            infoNFTTableView.topAnchor.constraint(equalTo: openSiteButton.bottomAnchor, constant: 40),
            infoNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoNFTTableView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}

// MARK: - UserInfoViewProtocol
extension UserInfoViewController: UserInfoViewProtocol {
    func displayUserInfo(with user: UserInfo) {
        nameLabel.text = user.name
        avatarImage.kf.setImage(with: user.avatar)
        descriptionLabel.text = user.description
        infoNFTTableView.reloadData()
    }
}

// MARK: - TableView Protocols

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoNFTTableCell = infoNFTTableView.dequeueReusableCell()
        if let user = presenter.user {
            cell.configure(with: user.nfts.count)
        }
        return cell
    }
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
    }
}
