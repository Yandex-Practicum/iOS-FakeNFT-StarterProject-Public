//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import UIKit
import Kingfisher

final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: PaymentViewModelProtocol?
    
    var paymentArray: [PaymentStruct] = []
    
    let paymentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PaymentCell.self, forCellWithReuseIdentifier: "paymentCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
}

// MARK: - Private methods
extension PaymentViewController {
    
    // MARK: - Functions & Methods
    /// Appearance customisation
    private func setupView() {
        NSLayoutConstraint.activate([
            paymentCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            paymentCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Setting properties
    private func setupProperties() {
        viewModel?.getСurrencies(completion: { payments in
            self.paymentArray = payments
            DispatchQueue.main.async {
                self.paymentCollection.reloadData()
            }
        })
        title = "Выберите способ оплаты"
        view.backgroundColor = .white
        view.addSubview(paymentCollection)
        paymentCollection.dataSource = self
        paymentCollection.delegate = self
    }
    
}

extension PaymentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paymentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath) as? PaymentCell
            else { return UICollectionViewCell() }
        let imageURL = URL(string: paymentArray[indexPath.row].image)
        cell.image.kf.setImage(with: imageURL)
        let name = paymentArray[indexPath.row].title
        cell.name.text = name
        let shortName = paymentArray[indexPath.row].name
        cell.shortName.text = shortName
        return cell
    }
    
}

extension PaymentViewController: UICollectionViewDelegate {
    
    
    
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.bounds.width / 2) - 22
        return CGSize(width: size, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
}

