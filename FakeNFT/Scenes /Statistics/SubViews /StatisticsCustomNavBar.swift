//
//  StatisticsCustomNavBar.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 14.07.2024.
//

import Foundation
import SnapKit
import UIKit

final class StatisticsCustomNavBar: UIView {
    let sortButton: UIButton
    let backButton: UIButton
    let titleLabel: UILabel

    init() {
        sortButton = UIButton(type: .system)
        backButton = UIButton(type: .system)
        titleLabel = UILabel()
        super.init(frame: .zero)
        prepareSortButton()
        initializeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeUI() {
        backgroundColor = .background
        prepareSortButton()
        prepareBackButton()
        prepareTitle()
        setupUI()
        activatingConstraints()
    }

    private func setupUI() {
        for subView in [backButton, sortButton, titleLabel] {
            self.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func activatingConstraints() {

        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(42)
            make.width.equalTo(42)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(9)
            make.top.equalToSuperview()
            make.height.equalTo(42)
            make.width.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(261)
            make.centerX.centerY.equalToSuperview()
        }
    }

    private func prepareSortButton() {
        sortButton.tintColor = .nftBlack
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
    }
    private func prepareBackButton() {
        backButton.setImage(UIImage(named:
                                        "backward"), for: .normal)
        backButton.tintColor = .nftBlack
    }

    private func prepareTitle() {
        titleLabel.text = "Коллекция NFT"
        titleLabel.font = .bodyBold
        titleLabel.textAlignment = .center
    }



     func isTitleInvisible(it_s newValue: Bool) {
        titleLabel.isHidden = newValue
    }
     func isSortButtonInvisible(it_s newValue: Bool) {
        sortButton.isHidden = newValue
    }

     func isBackButtonInvisible(it_s newValue: Bool) {
        backButton.isHidden = newValue
    }
}
