//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCollectionViewProtocol: AnyObject {
    func updateCollectionList(with items: [NFTItem])
}

final class UserCollectionViewController: UIViewController{
    var presenter: UserCollectionPresenterProtocol?
    private var selectedUser : NFTUser?
    private var customNavBar = StatisticsCustomNavBar()
    private var nftCollectionView : UICollectionView
    private let nftCollectionViewCellIdentifier = "nftCollectionViewCellIdentifier"
    private let interItemSpacing = CGFloat(integerLiteral: 9)
    private let interLinesSpacing = CGFloat(integerLiteral: 8)
    
    private var collectionList : [NFTItem] = []
    
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
        presenter?.updateSelf(view: self)
        collectionList = presenter?.getCollectionList() ?? []
        initializeUI()
    }
    
    private func initializeUI() {
        setupUI()
        prepareNavBar()
        prepareNFTCollectionView()
        activatingConstraints()
        }
    
    private func setupUI() {
        for subView in [customNavBar, nftCollectionView] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func prepareNavBar(){
        customNavBar.isBackButtonInvisible(it_s: false)
        customNavBar.isSortButtonInvisible(it_s: true)
        customNavBar.isTitleInvisible(it_s: false)
        customNavBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func prepareNFTCollectionView(){
        
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

        let collectionHeight = CGFloat(collectionList.count/3 * 192 + 12) 
        
        nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(view.snp.bottom)
           // make.height.equalTo(collectionHeight)
        }
    }
    
    //MARK:- OBJC functions
    @objc private func backButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
}

//MARK: - NFTCollectionView
extension UserCollectionViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
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
        return collectionList.count
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
           let imageURL = item.images.first{
            cell.setNFTName(with: item.name)
            cell.setNFTImage(with: imageURL)
            cell.setNFTPrice(with: item.price)
            cell.setNFTRating(with: item.rating)
        }
       return cell
    }
    
    
}


// MARK: - UsersCollectionViewProtocol

extension UserCollectionViewController: UserCollectionViewProtocol {
    func updateCollectionList(with collectionList: [NFTItem]) {
        self.collectionList = collectionList
        self.nftCollectionView.reloadData()
        self.activatingConstraints()
    }
}


extension UserCollectionViewController : StatisticsUserNFTCollectionViewCellDelegate{
    func onLikeButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
     //   guard let nftModel = cell.getNftModel() else { return }
       // presenter?.toggleLikeStatus(model: nftModel)
    }
    
    func addToCartButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
     //   guard let nftModel = cell.getNftModel() else { return }
     //   presenter?.toggleCartStatus(model: nftModel)
    }
    
    
}
