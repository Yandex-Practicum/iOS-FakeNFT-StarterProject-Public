//
//  CartScreenViewController.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 24.06.2023.
//

import UIKit
import Kingfisher

/// The class responsible for the operation of the cart screen
final class CartScreenViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        
        static let imageHeightWidth = CGFloat(108)
        static let labelWidth = CGFloat(180)
        
    }
    
    // MARK: - Properties
    var viewModel: CartViewModelProtocol?
    
    var cartArray: [CartStruct] = []
    
    private var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        blurView.frame = UIScreen.main.bounds
        return blurView
    }()
    
    let imageToDelete: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let deleteText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Вернуться", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let cartTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = false
        table.register(CartCell.self, forCellReuseIdentifier: "cartCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let cartInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
}

// MARK: - Private methods
extension CartScreenViewController {
    
    /// Appearance customisation
    private func setupView() {
        NSLayoutConstraint.activate([
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartInfo.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
    
    /// Setting properties
    private func setupProperties() {
        view.addSubview(cartTable)
        view.addSubview(imageToDelete)
        view.addSubview(cartInfo)
        buttonStack.addArrangedSubview(deleteButton)
        buttonStack.addArrangedSubview(cancelButton)
        cartTable.dataSource = self
        cartTable.delegate = self
        getData(ids: ["1", "2", "4", "6"])
    }
    
    private func getData(ids: [String]) {
        ids.forEach { id in
            viewModel?.getNFTs(nftID: id, completion: { cart in
                self.cartArray.append(cart)
                DispatchQueue.main.async {
                    self.cartTable.reloadData()
                }
            })
        }
    }
    
}

// MARK: - Extension for CartCellDelegate
extension CartScreenViewController: CartCellDelegate {
    
    func showDeleteView() {
        window?.addSubview(blurView)
        window?.addSubview(imageToDelete)
        window?.addSubview(deleteText)
        window?.addSubview(buttonStack)
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1.0
            NSLayoutConstraint.activate([
                self.deleteText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.deleteText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.deleteText.widthAnchor.constraint(equalToConstant: Constants.labelWidth),
                self.imageToDelete.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.imageToDelete.bottomAnchor.constraint(equalTo: self.deleteText.topAnchor, constant: -12),
                self.imageToDelete.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
                self.imageToDelete.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
                self.buttonStack.topAnchor.constraint(equalTo: self.deleteText.bottomAnchor, constant: 20),
                self.buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.deleteButton.widthAnchor.constraint(equalToConstant: 127),
                self.cancelButton.widthAnchor.constraint(equalToConstant: 127),
                self.deleteButton.heightAnchor.constraint(equalToConstant: 44),
                self.cancelButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
}

// MARK: - Extension for UITableViewDataSource
extension CartScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell
            else { return UITableViewCell() }
        let rating = cartArray[indexPath.row].nftRating
        let name = cartArray[indexPath.row].nftName
        let price = "\(cartArray[indexPath.row].nftPrice) ETH"
        let imageURL = URL(string: cartArray[indexPath.row].nftImages.first ?? "")
        cell.setupRating(rating: rating)
        cell.nftName.text = name
        cell.nftPrice.text = String(price)
        cell.nftImage.kf.setImage(with: imageURL)
        cell.delegate = self
        return cell
    }
    
}

// MARK: - Extension for UITableViewDelegate
extension CartScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
