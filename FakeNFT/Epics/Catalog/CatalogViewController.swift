import UIKit

final class CatalogViewController: UIViewController {
    let sortButton = UIButton() // возможно в презентер
    let table = UITableView() // возможно в презентер
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite // возможно в презентер
        configureButton() // возможно в презентер
        configureTable() // возможно в презентер
    }
    
    private func configureButton() { // возможно в презентер
        sortButton.setImage(UIImage(), for: .normal)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureTable() { // возможно в презентер
        if !view.contains(sortButton) { return }
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10 // Временно
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.backgroundColor = .clear
        cell.contentView.addSubview(UIImageView(image: UIImage.mockCollection))
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
