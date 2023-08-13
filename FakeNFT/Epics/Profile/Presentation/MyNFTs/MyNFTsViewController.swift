import UIKit

final class MyNFTsViewController: UIViewController {
    // MARK: - Private properties
    private let tableView = UITableView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureNavigationController()
        addingUIElements()
        layoutConfigure()
    }
    
    // MARK: - Private methods
    // MARK: - Private methods
    private func addingUIElements() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -39),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        // Создание кнопки "Назад"
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: symbolConfiguration) ?? UIImage()
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        
        // Создание кнопки с изображением справа
        let imageButton = UIBarButtonItem(image: .sortButton, style: .plain, target: self, action: #selector(imageButtonTapped))
        imageButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = imageButton
    }
    
    private func tableViewConfigure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
    }
    
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func imageButtonTapped() {
        // TODO: Добавить сортировку после добавления в BASE
    }
}

extension MyNFTsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
