import UIKit
import ProgressHUD

class StatisticViewController: UIViewController {
    
    // MARK: - Public Properties
    let servicesAssembly: ServicesAssembly
    
    // MARK: - Private Properties
    private let sortButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var users = Users()
    private let statisticNetworkServise = StatisticNetworkServise()
    private let titleAlert = NSLocalizedString("Statistic.sortAlert.title", comment: "")
    private let sortByName = NSLocalizedString("Statistic.sortAlert.name", comment: "")
    private let sortByRating = NSLocalizedString("Statistic.sortAlert.rating", comment: "")
    private let closeAlert = NSLocalizedString("Statistic.sortAlert.close", comment: "")
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupCollectionView()
        setupSortButton()
        setupConstraint()
        reloadUsers()
    }
    
    // MARK: - IB Actions
    @objc private func onClick() {
        let actionSheet = UIAlertController(title: nil, message: titleAlert, preferredStyle: .actionSheet)
        let sortByNameAction = UIAlertAction(title: sortByName, style: .default) { [weak self] _ in
            guard let self = self else { return }
            sortedByName()
        }
        
        let sortByRatingAction = UIAlertAction(title: sortByRating, style: .default) { [weak self] _ in
            guard let self = self else { return }
            sortedByRating()
        }
        
        actionSheet.addAction(sortByNameAction)
        actionSheet.addAction(sortByRatingAction)
        actionSheet.addAction(UIAlertAction(title: closeAlert, style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    // MARK: - Private Methods
    private func sortedByName() {
        users.sort(by: {$0.name < $1.name})
        collectionView.reloadData()
    }
    
    private func sortedByRating() {
        users.sort(by: {$0.rating < $1.rating})
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupSortButton() {
        view.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.backgroundColor = UIColor(named: "YPWhite")
        sortButton.addTarget(self,
                             action: #selector(onClick),
                             for: .touchUpInside)
        sortButton.setImage(UIImage(named: "sortButtonImage"), for: .normal)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 324),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    private func reloadUsers() {
        ProgressHUD.show()
        statisticNetworkServise.fetchUsers() { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                ProgressHUD.dismiss()
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.dismiss()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension StatisticViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = cell as? StatisticCollectionViewCell else {
            return StatisticCollectionViewCell()
        }
        cell.updateNameLabel(name: users[indexPath.item].name)
        cell.updateRatingLabel(rating: users[indexPath.item].rating)
        cell.updateNumberNftLabel(numberNft: String(users[indexPath.item].nfts.count))
        if let avatarURL = URL(string: users[indexPath.item].avatar) {
            cell.updateProfileImage(avatar: avatarURL)
        } else {
            cell.putPlugProfileImage()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StatisticViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343,
                      height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
