import UIKit

final class ProfileViewController: UIViewController {

    private  var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 70 / 2
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    private lazy var urlTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showWebView), for: .touchUpInside)

        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ProfileVCTableViewCell.self, forCellReuseIdentifier: ProfileVCTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        setupView()
        setupNavBar()
    }

    private func setupNavBar() {
        let button = UIBarButtonItem(image: UIImage(named: "square.and.pencil"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(editProfile))
        button.tintColor = .label
        navigationItem.setRightBarButtonItems([button], animated: true)
    }

    private func setupView() {

        avatarImageView.image = UIImage(named: "avatar")
        nameLabel.text = "Joaquin Phoenix"
        urlTextButton.setTitle("yandex.ru", for: .normal)
        descriptionLabel.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше на моем сайте. Открыт к коллаборяциям"

    }

    private func layout() {
        [tableView, nameLabel, descriptionLabel, urlTextButton, avatarImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            urlTextButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            urlTextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            urlTextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: urlTextButton.bottomAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 54)

        ])
    }

    @objc private func showWebView() {

    }

    @objc private func editProfile() {

    }

}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
             let myNftVC = MyNftViewController()
            navigationController?.pushViewController(myNftVC, animated: true)
        case 1:
            let myNftVC = MyNftViewController()
            navigationController?.pushViewController(myNftVC, animated: true)
        default:
            return
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileVCTableViewCell.identifier,
            for: indexPath) as? ProfileVCTableViewCell else {
            assertionFailure("Не удалось создать ячейку таблыцы ProfileVCTableViewCell")
            return UITableViewCell()
        }
        cell.configureCell(text: "Мои NFT")
        return cell
    }

}
