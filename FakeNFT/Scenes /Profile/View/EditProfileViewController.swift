//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 12.04.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol EditProfileViewControllerProtocol: AnyObject {
    func setProfile(profile: Profile)
    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?)
}

final class EditProfileViewController: UIViewController {
    //MARK:  - Public Properties
    var presenter: EditProfilePresenter?
    var cell: EditProfileCell?
    weak var editProfilePresenterDelegate: EditProfilePresenterDelegate?
    
    //MARK:  - Private Properties
    private var nameTextView = ""
    private var descriptionTextView = ""
    private var siteTextView = ""
    private var newAvatarURL: String?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "ypBlack")
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(Self.closeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileEditImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatarChangeImage")
        let action = UITapGestureRecognizer(
            target: self,
            action: #selector(changeImageDidTap(_:))
        )
        image.addGestureRecognizer(action)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var editProfileCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(named: "ypWhite")
        collection.register(EditProfileCell.self, forCellWithReuseIdentifier: EditProfileCell.cellID)
        collection.register(EditProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EditProfileHeader.headerID)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var loadAvatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular17
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Загрузить изображение"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initializers
    init(presenter: EditProfilePresenter?, cell: EditProfileCell?) {
        self.presenter = presenter
        self.cell = cell
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func closeButtonTap() {
        presenter?.updateProfile(
            name: nameTextView,
            description: descriptionTextView,
            website: siteTextView,
            newAvatarURL: newAvatarURL
        )
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeImageDidTap(_ sender: UITapGestureRecognizer) {
        print("Загрузка изображения")
        loadAvatarLabel.isHidden = false
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        presenter?.viewDidLoad()
    }
    //MARK: - Private Methods
    private func customizingScreenElements() {
        view.backgroundColor = .systemBackground
        [closeButton, profileEditImage, editProfileCollection, loadAvatarLabel].forEach {view.addSubview($0)}
        [closeButton, profileEditImage, loadAvatarLabel, editProfileCollection].forEach {($0).translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            
            profileEditImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileEditImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileEditImage.widthAnchor.constraint(equalToConstant: 70),
            profileEditImage.heightAnchor.constraint(equalToConstant: 70),
            
            loadAvatarLabel.topAnchor.constraint(equalTo: profileEditImage.bottomAnchor, constant: 11),
            loadAvatarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            editProfileCollection.topAnchor.constraint(equalTo: profileEditImage.bottomAnchor, constant: 24),
            editProfileCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editProfileCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editProfileCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension EditProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditProfileCell.cellID, for: indexPath) as? EditProfileCell else { fatalError("Failed to cast UICollectionViewCell to EditProfileCell")
        }
        switch indexPath.section {
        case 0:
            cell.textViewInCell.text = "\(nameTextView)"
        case 1:
            cell.textViewInCell.text = "\(descriptionTextView)"
        case 2:
            cell.textViewInCell.text = "\(siteTextView)"
        default:
            fatalError("Сollection section numbering error")
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EditProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = editProfileCollection.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: EditProfileHeader.headerID,for: indexPath) as? EditProfileHeader
            else { fatalError("Failed to cast UICollectionReusableView to TrackersHeader") }
            
            switch indexPath.section {
            case 0:
                header.titleLabel.text = "Имя"
            case 1:
                header.titleLabel.text = "Описание"
            case 2:
                header.titleLabel.text = "Сайт"
            default: break
            }
            return header
        default:
            fatalError("Unexpected element kind")
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8,
                            left: 16,
                            bottom: 24,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 343, height: 44)
        case 1:
            return CGSize(width: 343, height: 132)
        case 2:
            return CGSize(width: 343, height: 44)
        default:
            return CGSize(width: 343, height: 44) // подумать
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 50, height: 28)
        } else {
            return CGSize(width: collectionView.frame.width, height: 28)
        }
    }
}

// MARK: - EditProfileViewControllerProtocol
extension EditProfileViewController: EditProfileViewControllerProtocol {
    func setProfile(profile: Profile) {
        nameTextView = profile.name
        descriptionTextView = profile.description
        siteTextView = profile.website
        if let avatarURLString = profile.avatar {
            let avatarURL = URL(string: avatarURLString)
            if let url = avatarURL {
                updateAvatar(url: url, options: nil)
            } else {
                print("Avatar is nil")
            }
        }
    }
    
    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?) {
        profileEditImage.kf.indicatorType = .activity
        profileEditImage.kf.setImage(
            with: url,
            options: options)
    }
}

