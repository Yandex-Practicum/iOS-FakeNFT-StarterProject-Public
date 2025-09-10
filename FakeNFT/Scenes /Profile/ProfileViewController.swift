import UIKit


final class ProfileViewController: UIViewController, LoadingView {
    //MARK: UI
    private lazy var profileCardView: ProfileCardView = {
        let view = ProfileCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.onLinkTapped = { [weak self] in
            guard let self = self, let websiteString = self.profile?.website, let url = URL(string: websiteString) else {
                return
            }
            let webVC = WebViewController(urlString: websiteString)
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: Properties
    private let servicesAssembly: ServicesAssembly
    private let profileService: ProfileService
    private var profile: Profile?
    
    
    //MARK: Init
    init (servicesAssembly: ServicesAssembly, profileService: ProfileService){
        self.servicesAssembly = servicesAssembly
        self.profileService = profileService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadProfile()
    }
    
    private func setupUI() {
        view.addSubviews(profileCardView, tableView, activityIndicator)
        
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.spacingXXL),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: LayoutConstants.spacingExtreme),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: LayoutConstants.rowHeight * 2 ),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func loadProfile() {
        showLoading()
        
        profileCardView.isHidden = true
        tableView.isHidden = true
        
        profileService.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.hideLoading() // Используем метод протокола
                    self.profileCardView.isHidden = false
                    self.tableView.isHidden = false
                    
                    self.profile = profile
                    self.profileCardView.configure(with: profile)
                    self.tableView.reloadData()
                case .failure(let error):
                    //TODO: Show alert to user
                    print("Error fetching profile: \(error)")
                }
            }
        }
    }
    
    //mock
    //    private func loadProfile() {
    //
    //        let mockProfile = Profile(
    //            id: "1",
    //            name: "Test User",
    //            avatar: "https://.../some-avatar.jpg",
    //            bio: "Mock bio.",
    //            website: "https://yandex.ru/legal/practicum_termsofuse/",
    //            nfts: ["1", "2"],
    //            likes: ["3", "4"]
    //        )
    //
    //        self.profile = mockProfile
    //
    //        // После получения данных вызываем configure
    //        profileCardView.configure(with: mockProfile)
    //        tableView.reloadData()
    //    }
    
    
    @objc
    private func editButtonTapped() {
        //todo
    }
    
}
//MARK: TableView methods
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProfileAction.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        let action = ProfileAction.allCases[indexPath.row]
        
        let title = action.localizedTitle
        var subtitle = ""
        
        if let profile = self.profile, let count = action.count(from: profile) {
            subtitle = " (\(count))"
        }
        
        cell.textLabel?.text = title + subtitle
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .label
        cell.accessoryView = chevron
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = ProfileAction.allCases[indexPath.row]
        
        guard let profile = self.profile else { return }
        
        if let viewControllerToPresent = action.makeViewController(profile: profile, servicesAssembly: servicesAssembly) {
            self.navigationController?.pushViewController(viewControllerToPresent, animated: true)
        }
    }
    
}
