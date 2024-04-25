//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 04.04.2024.
//

import UIKit

protocol MyNFTLikesDelegate: AnyObject {
    func didUpdateLikedNFTCount(count: Int)
}

protocol MyNFTViewControllerProtocol: AnyObject {
    var presenter: MyNFTPresenter? { get set }
    func updateMyNFTs(nfts: [NFT]?)
}

final class MyNFTViewController: UIViewController {
    //MARK:  - Public Properties
    var presenter: MyNFTPresenter?
    
    //MARK:  - Private Properties
    private var myNFTs: [NFT] = []
    private var nftID: [String]
    private var likedNFT: [String]
    private let profileService = ProfileService.shared
    private let editProfileService = EditProfileService.shared
    
    private lazy var returnButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(returnButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var sortingButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "text.justify.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(sortingButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyNFTCell.self,
            forCellReuseIdentifier: MyNFTCell.cellID
        )
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var  stubLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет NFT"
        label.font = UIFont.sfProBold17
        label.textColor = UIColor(named: "ypBlack")
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    init(nftID: [String], likedID: [String]) {
        self.nftID = nftID
        self.likedNFT = likedID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func returnButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sortingButtonTap() {
        let contextMenu = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        contextMenu.addAction(UIAlertAction(title: "По цене", style: .default, handler: { _ in
            print("Кнопка сортировки по цене")
        }))
        contextMenu.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { _ in
            print("Кнопка сортировки по рейтингу")
        }))
        contextMenu.addAction(UIAlertAction(title: "По названию", style: .default, handler: { _ in
            print("Кнопка сортировки по названию")
        }))
        contextMenu.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(contextMenu, animated: true)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        
        presenter = MyNFTPresenter(nftID: self.nftID, likedNFT: self.likedNFT, editProfileService: editProfileService)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private Methods
    private func customizingStub () {
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        sortingButton.tintColor = UIColor(named: "ypWhite")
        sortingButton.isEnabled = false
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        stubLabel.isHidden = true
    }
    private func customizingNavigation() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.title = "Мой NFT"
        navigationItem.leftBarButtonItem = returnButton
        navigationItem.rightBarButtonItem = sortingButton
    }
    
    private func customizingScreenElements() {
        view.addSubview(myNFTTableView)
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.nfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.cellID,for: indexPath) as? MyNFTCell else {fatalError("Could not cast to MyNFTCell")}
        
        guard let nft = presenter?.nfts[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.changingNFT(nft: nft)
        let isLiked = presenter?.isLiked(id: nft.id) ?? true
        cell.setIsLiked(isLiked: isLiked)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - MyNFTViewControllerProtocol
extension MyNFTViewController: MyNFTViewControllerProtocol {
    func updateMyNFTs(nfts: [NFT]?) {
        guard let presenter = presenter else {
            print("Presenter is nil")
            return
        }
        
        guard let nfts = nfts else {
            print("Received nil NFTs")
            return
        }
        
        presenter.nfts = nfts
        DispatchQueue.main.async {
            self.myNFTTableView.reloadData()
        }
    }
}

// MARK: - MyNFTCellDelegate
extension MyNFTViewController: MyNFTCellDelegate {
    func didTapLikeButton(nftID: String) {
        presenter?.tapLike(id: nftID)
        if let index = self.presenter?.nfts.firstIndex(where: { $0.id == nftID }) {
            let indexPath = IndexPath(row: index, section: 0)
            
            self.myNFTTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
