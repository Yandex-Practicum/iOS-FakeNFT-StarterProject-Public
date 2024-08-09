//
//  placeholderView.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 09.08.2024.
//

import Foundation
import SnapKit
import UIKit


final class PlaceholderView : UIView{
    private let placeholderLabel: UILabel
    private let placeHolderView: UIView
    
    init() {
        placeholderLabel = UILabel()
        placeHolderView = UIView()
        super.init(frame: .zero)
        initializeUI()
    }

    private func initializeUI() {
        backgroundColor = .background
        preparingUIElements()
        setupUI()
        activatingConstraints()
    }
    
    private func preparingUIElements(){
        placeholderLabel.text = "У пользователя нет NFT"
        placeholderLabel.font = .bodyBold
        placeholderLabel.textAlignment = .center
    }
    
    private func setupUI(){
        for subView in [placeholderLabel, placeHolderView] {
            self.addSubview(subView)
        }
    }
    private func activatingConstraints(){
        placeholderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(placeHolderView.snp.centerY)
            make.centerX.equalTo(placeHolderView.snp.centerX)
        }
        
        placeHolderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  }
