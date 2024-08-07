//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit
import ProgressHUD

protocol UserCollectionViewProtocol: AnyObject {
    func updateCollectionList(with items: [NFTItem])
    func showLoading()
    func hideLoading()
}

final class UserCollectionViewController: UIViewController {
    var presenter: UserCollectionPresenterProtocol?
    private var customNavBar = StatisticsCustomNavBar()
    private var nftCollectionView: UICollectionView
    private let nftCollectionViewCellIdentifier = "nftCollectionViewCellIdentifier"
    private let interItemSpacing = CGFloat(integerLiteral: 9)
    private let interLinesSpacing = CGFloat(integerLiteral: 8)
    
    private let emptyListImageView :  UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        imageView.frame.size = CGSize(width: 80, height: 80)
        imageView.tintColor = .nftPlaceHolderGray
        imageView.isHidden = true
        return imageView
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        prepareNavBar()
        prepareNFTCollectionView()
        activatingConstraints()
        handleStartView()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        presenter?.loadData { [weak self] in
            self?.nftCollectionView.reloadData()
            self?.handleStartView()
        
        }
    }
    
    private func setupUI() {
        for subView in [customNavBar, nftCollectionView, emptyListImageView] {
            view.addSubview(subView)
        }
    }
    
    private func prepareNavBar() {
        customNavBar.isBackButtonInvisible(it_s: false)
        customNavBar.isSortButtonInvisible(it_s: true)
        customNavBar.isTitleInvisible(it_s: false)
        customNavBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func prepareNFTCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.register(StatisticsUserNFTCollectionViewCell.self, forCellWithReuseIdentifier: nftCollectionViewCellIdentifier)
    }
    
    private func activatingConstraints() {
        customNavBar.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(42)
        }
        
        nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        emptyListImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
     func handleStartView(){
         guard let presenter = presenter else {return}
         if (presenter.getCollectionList().isEmpty){
            showEmptyListView()
        }else{
            hideEmptyListView()
        }
    }
    
    private func showEmptyListView() {
        emptyListImageView.isHidden = false
        view.bringSubviewToFront(emptyListImageView)
    }
    private func hideEmptyListView() {
        emptyListImageView.isHidden = true
        view.sendSubviewToBack(emptyListImageView)
    }
    
    // MARK: - OBJC Functions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension UserCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interLinesSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getCollectionList().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = interItemSpacing * 3 + view.safeAreaInsets.left + view.safeAreaInsets.right
        let itemWidth = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: itemWidth, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nftCollectionViewCellIdentifier, for: indexPath) as? StatisticsUserNFTCollectionViewCell else {
            return StatisticsUserNFTCollectionViewCell()
        }
        if let item = presenter?.getCollectionList()[indexPath.row],
           let imageURL = item.images.first {
            cell.setNFTName(with: item.name)
            cell.setNFTImage(with: imageURL)
            cell.setNFTPrice(with: item.price)
            cell.setNFTRating(with: item.rating)
        }
        return cell
    }
}

// MARK: - UserCollectionViewProtocol

extension UserCollectionViewController: UserCollectionViewProtocol {
    func updateCollectionList(with collectionList: [NFTItem]) {
            self.nftCollectionView.reloadData()
        handleStartView()
    }
    
    func showLoading() {
        ProgressHUD.show("Loading...")
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
 
}

// MARK: - StatisticsUserNFTCollectionViewCellDelegate

extension UserCollectionViewController: StatisticsUserNFTCollectionViewCellDelegate {
    func onLikeButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
        // Handle like button tap
    }
    
    func addToCartButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
        // Handle add to cart button tap
    }
}
