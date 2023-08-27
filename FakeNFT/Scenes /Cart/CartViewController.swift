import UIKit

final class CartViewController: UIViewController {

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sort"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let purchaseView: CartView = {
        let view = CartView()
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.Bold.size17
        label.backgroundColor = UIColor.systemBackground
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cartTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
     override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        setupView()
    }

    @objc func sortButtonTapped() {
        // TODO: make sorting logic
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        view.addSubview(placeholderLabel)
        view.addSubview(purchaseView)
        view.addSubview(cartTableView)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 22),
            purchaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            purchaseView.heightAnchor.constraint(equalToConstant: 78),
            purchaseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cartTableView.bottomAnchor.constraint(equalTo: purchaseView.topAnchor)
        ])
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.identifier,
            for: indexPath) as? CartTableViewCell else { fatalError() }
        cell.configureCell()
        return cell
    }
}
