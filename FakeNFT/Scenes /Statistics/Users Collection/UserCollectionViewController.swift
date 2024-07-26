//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCollectionViewProtocol: AnyObject {

}

final class UserCollectionViewController: UIViewController {

    var presenter: UserCollectionPresenterProtocol!
    private var customNavBar = StatisticsCustomNavBar()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.backgroundColor = .green
        initializeUI()
    }
    
    private func initializeUI() {
        setupUI()
        prepareNavBar()
        activatingConstraints()
        }
    
    private func setupUI() {
        for subView in [customNavBar ] {
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
    
    private func activatingConstraints() {
        customNavBar.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(42)
        }
    }
    
    //MARK:- OBJC functions
    @objc private func backButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
}



// MARK: - UsersCollectionViewProtocol

extension StatisticsViewController: UserCollectionViewProtocol {

}
