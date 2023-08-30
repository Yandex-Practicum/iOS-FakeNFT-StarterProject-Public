import UIKit
import Kingfisher

final class StatisticUserViewController: UIViewController {
    
    // MARK: - Private Dependencies
    private var statisticUserViewModel: StatisticUserViewModel
    
    // MARK: - UI
    private lazy var stackProfileView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        if let url = URL(string: statisticUserViewModel.profile.avatar) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .captionLargeBold
        label.textColor = .blackDay
        label.text = statisticUserViewModel.profile.name
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .bodySmallerRegular
        label.textColor = .blackDay
        label.text = statisticUserViewModel.profile.description
        return label
    }()
    
    private lazy var profileButton = BaseWhiteButton(with: L10n.Statistic.Profile.ButtonUser.title)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticUserTableViewCell.self)
        return tableView
    }()
    
    private lazy var disclosureImageView: UIImageView = {
        let disclosureImage = UIImage(systemName: "chevron.forward")
        let disclosureImageView = UIImageView(image: disclosureImage)
        disclosureImageView.tintColor = .blackDay
        return disclosureImageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Init
    init(statisticUserViewModel: StatisticUserViewModel) {
        self.statisticUserViewModel = statisticUserViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatisticUserViewController {
    
    // MARK: - Objc Functions
    @objc func didTapProfileButton() {
        let webViewViewModel = WebViewViewModel()
        let url = URL(string: statisticUserViewModel.profile.website)
        let webViewViewController = WebViewViewController(viewModel: webViewViewModel, url: url)
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        [stackProfileView,
         bioLabel,
         profileButton,
         tableView
        ].forEach(view.setupView)
        
        [avatarImageView,
         nameLabel
        ].forEach(stackProfileView.addArrangedSubview)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackProfileView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarImageView.centerYAnchor.constraint(equalTo: stackProfileView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: stackProfileView.leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: stackProfileView.centerYAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: stackProfileView.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 28),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
        addTargets()
    }
    
    private func addTargets() {
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
    }
}

// MARK: - TableViewDataSource
extension StatisticUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticUserTableViewCell = tableView.dequeueReusableCell()
        let title = L10n.Statistic.Profile.ButtonCollection.title + " (\(statisticUserViewModel.profile.nfts.count))"
        cell.setupTitleLabel(with: title)
        cell.accessoryView = disclosureImageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}

// MARK: - TableViewDelegate
extension StatisticUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statisticNFTCollectionViewModel = StatisticNFTCollectionViewModel(nftsId: statisticUserViewModel.profile.nfts)
        let statisticNFTCollectionViewController = StatisticNFTCollectionViewController(statisticNFTViewModel: statisticNFTCollectionViewModel)
        navigationController?.pushViewController(statisticNFTCollectionViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
