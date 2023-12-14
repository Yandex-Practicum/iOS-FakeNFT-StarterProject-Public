//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit

final class StatisticsVIewController: UIViewController {
    private let servicesAssembly: ServicesAssembly

    private lazy var sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return sortButton
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        addSubviews()
        setupConstraints()
    }

    @objc
    private func sortButtonTapped() {
        let alert = UIAlertController(title: "Sort", message: "Choose sort type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "By name", style: .default, handler: { _ in
            print("Sort by name")
        }))
        alert.addAction(UIAlertAction(title: "By date", style: .default, handler: { _ in
            print("Sort by date")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    private func addSubviews() {
        view.addSubview(sortButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                sortButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 44 + 2),
                sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
                sortButton.heightAnchor.constraint(equalToConstant: 42),
                sortButton.widthAnchor.constraint(equalToConstant: 42)
            ]
        )
    }
}
