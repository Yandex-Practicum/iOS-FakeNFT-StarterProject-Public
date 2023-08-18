//
//  ProfileCollectionViewController.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import UIKit
import ProgressHUD

final class ProfileCollectionViewController: UIViewController {
    
    var nftIds: [Int] = []
    
    private let viewModel = ProfileCollectionViewModel()
    private var nftList: [Nft] = []
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .YPBlack
        label.text = "Коллекция NFT"
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var nftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(NftCollectionCell.self)
        return collectionView
    }()
    
    private let params: GeometricParams = GeometricParams(cellCount: 3,
                                                          leftInset: 9,
                                                          rightInset: 9,
                                                          cellHorizontalSpacing: 0,
                                                          cellVerticalSpacing: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nftCollectionView.delegate = self
        nftCollectionView.dataSource = self
        
        addViews()
        setUpConstraints()
        
        bind()
        viewModel.getNftCollection(nftIdList: nftIds)
    }
    
    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bind() {
        viewModel.$nftList.bind(action: { [weak self] nftList in
            self?.nftList = nftList
            self?.nftCollectionView.reloadData()
        })
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            self?.presentErrorDialog(message: errorMessage)
        }
        viewModel.$isLoading.bind { isLoading in
            if isLoading {
                ProgressHUD.show()
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func addViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(nftCollectionView)
    }
    
    private func setUpConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftCollectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29)
        ])
    }
    
}

extension ProfileCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCollectionCell = nftCollectionView.dequeueReusableCell(indexPath: indexPath)
        
        cell.configure(nft: nftList[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellVerticalSpacing
    }

}

extension ProfileCollectionViewController: NftCollectionCellDelegate {
    func onAddToCart(nftName: String) {
        let alert = UIAlertController(title: "NFT \(nftName) добавлена в корзину", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
