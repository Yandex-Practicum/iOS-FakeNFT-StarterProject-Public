//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit


protocol UserCardViewProtocol: AnyObject {
    func updateUser(with user: NFTUser?)
}

final class UserCardViewController: UIViewController, UserCardViewProtocol {
    var presenter: UserCardPresenterProtocol?
    private var user : NFTUser?
    private var customNavBar = StatisticsCustomNavBar()
    private var userCard = UIView()
    private var userWebPageLinkButton = UIButton(type: .system)
    private var nftUserCollectionNavItem = UIView()
    private var userImageImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var userBioLabel = UILabel()
    private var navItemTitle = UILabel()
    private var navItemItemsAmount = UILabel()
    private var navItemButton = UIButton()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.updateSelf(view: self)
        initializeUI()
    }
    private func initializeUI() {
        setupUI()
        prepareNavBar()
        prepareUserCard()
        prepareWebPageLinkButton()
        prepareNavItem()
        updateUIElements()
        activatingConstraints()
    }
    
    private func setupUI() {
        for subView in [customNavBar, userCard, userWebPageLinkButton, nftUserCollectionNavItem ] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func updateUIElements(){
        presenter?.updateUser()
        if let userToShow = user {
            if let url = URL(string: userToShow.avatar) {
                userImageImageView.loadImage(from: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
                userImageImageView.tintColor = .nftPlaceHolderGray
        }
            userNameLabel.text = userToShow.name
            userBioLabel.text = userToShow.description
            navItemItemsAmount.text = "(\(userToShow.nfts.count))"
        }
    }
    
    private func prepareNavBar(){
        customNavBar.isBackButtonInvisible(it_s: false)
        customNavBar.isSortButtonInvisible(it_s: true)
        customNavBar.isTitleInvisible(it_s: true)
        customNavBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func prepareUserCard(){
        userCard.frame = CGRect(x: 0, y: 0, width: 375, height: 162)
        userCard.backgroundColor = .background
        userImageImageView.image = UIImage(systemName: "person.crop.circle.fill")
        userImageImageView.layer.cornerRadius = 35
        userImageImageView.clipsToBounds = true
        
        userNameLabel.textAlignment = .natural
        userNameLabel.font = .headline3
        userNameLabel.textColor = .nftBlack
        userNameLabel.text = "Unknown user"
        
        userBioLabel.numberOfLines = 0
        userBioLabel.text = "No description available"
        userBioLabel.font = .caption2
        userBioLabel.textAlignment = .natural
        
        for subView in [userImageImageView, userNameLabel, userBioLabel]{
            subView.translatesAutoresizingMaskIntoConstraints = false
            userCard.addSubview(subView)
        }
        
    }
    
    private func prepareWebPageLinkButton(){
        userWebPageLinkButton.frame = CGRect(x: 0, y: 0, width: 343, height: 20)
        userWebPageLinkButton.layer.borderWidth = 1.0
        userWebPageLinkButton.layer.cornerRadius = 16
        userWebPageLinkButton.setTitle("Перейти на сайт пользователя", for: .normal)
        userWebPageLinkButton.tintColor = .nftBlack
        userWebPageLinkButton.titleLabel?.font = .caption1
        userWebPageLinkButton.addTarget(self, action: #selector(openUserWebPage), for: .touchUpInside)
    }
    
    private func prepareNavItem(){
        nftUserCollectionNavItem.frame = CGRect(x: 0, y: 0, width: 375, height: 54)
        nftUserCollectionNavItem.backgroundColor = .background
        nftUserCollectionNavItem.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCollectionNFTScreen))
        nftUserCollectionNavItem.addGestureRecognizer(tapGestureRecognizer)
        
        
        navItemButton = UIButton(type: .system)
        navItemButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        navItemButton.tintColor = .nftBlack
        navItemButton.addTarget(self, action: #selector(showCollectionNFTScreen), for: .touchUpInside)
        
        navItemTitle.text = "Коллекция NFT"
        navItemTitle.font = .bodyBold
        navItemTitle.textAlignment = .natural
        
        navItemItemsAmount.text = "(0)"
        navItemItemsAmount.font = .bodyBold
        navItemItemsAmount.textAlignment = .center
        
        for subView in [navItemButton, navItemTitle, navItemItemsAmount]{
            subView.translatesAutoresizingMaskIntoConstraints = false
            nftUserCollectionNavItem.addSubview(subView)
        }
    }
    
    private func activatingConstraints() {
        customNavBar.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(42)
        }
        
        userCard.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(162)
        }
        
        userWebPageLinkButton.snp.makeConstraints { make in
            make.top.equalTo(userCard.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        nftUserCollectionNavItem.snp.makeConstraints { make in
            make.top.equalTo(userWebPageLinkButton.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(54)
        }
        userImageImageView.snp.makeConstraints { make in
            make.top.equalTo(userCard)
            make.leading.equalTo(userCard).inset(16)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageImageView.snp.trailing).offset(16)
            make.trailing.equalTo(userCard)
            make.centerY.equalTo(userImageImageView)
            make.height.equalTo(28)
        }
        userBioLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageImageView.snp.bottom).offset(20)
            make.leading.equalTo(userCard).inset(16)
            make.trailing.equalTo(userCard).inset(18)
            make.height.equalTo(72)
        }
        navItemTitle.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(nftUserCollectionNavItem).inset(16)
            make.height.equalTo(22)
        }
        
        navItemItemsAmount.snp.makeConstraints { make in
            make.leading.equalTo(navItemTitle.snp.trailing).offset(8)
            make.top.bottom.equalTo(nftUserCollectionNavItem).inset(16)
            make.height.equalTo(22)
        }
        navItemButton.snp.makeConstraints { make in
            make.trailing.equalTo(nftUserCollectionNavItem).inset(16)
            make.top.bottom.equalTo(nftUserCollectionNavItem).inset(20)
            make.height.equalTo(14)
            make.width.equalTo(8)
        }
    }
    
    
    
    //MARK:- OBJC functions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func showCollectionNFTScreen(){
        loadUserCollection()
    }
    
    @objc private func openUserWebPage() {
        if let url = URL(string: user?.website ?? "https://www.yandex.ru") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
extension UserCardViewController {
    func loadUserCollection(){
        let userCollectionViewController = UserCollectionViewController()
        userCollectionViewController.modalPresentationStyle = .fullScreen
        present(userCollectionViewController, animated: true, completion: nil)
    }
}


// MARK: - UsersCardViewProtocol

extension UserCardViewController: UserCollectionViewProtocol {
    func updateUser(with selectedUser: NFTUser?){
        self.user = selectedUser
    }
}
