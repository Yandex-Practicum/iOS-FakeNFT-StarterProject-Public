//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Chingiz on 19.04.2024.
//

import UIKit
import Kingfisher

protocol StatisticsViewControllerProtocol {
    var presenter: StatisticPresenterProtocol { get set }
}

final class StatisticsViewController: UIViewController & StatisticsViewControllerProtocol {
    
    var presenter: StatisticPresenterProtocol = StatisticsPresenter()
    
    //MARK: - Private
    
    private lazy var ratingCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(RatingCell.self, forCellWithReuseIdentifier: RatingCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(named: "vector"), for: .normal)
        button.addTarget(self, action: #selector(sortButtontapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setNavBar()
        presenter.getStatistic {
            self.ratingCollectionView.reloadData()
            UIBlockingProgressHUD.dismiss()
           
            
        }
        
    }
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(ratingCollectionView)
        UIBlockingProgressHUD.show()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            ratingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ratingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ratingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ratingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
    private func setNavBar() {
        let custom = UIBarButtonItem(customView: sortButton)
        navigationController?.navigationBar.topItem?.setRightBarButton(custom, animated: false)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    @objc private func sortButtontapped() {
        let alertController =  UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "По имени", style: .default) { action in
            print("name")
        }
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { action in
            print("rating")
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel) { action in
            self.dismiss(animated: true)
        }
        
        [nameAction, ratingAction, closeAction].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)

    }
}

// MARK: - UICollectionViewDataSource

extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCell.identifier, for: indexPath) as? RatingCell else {
            return UICollectionViewCell()
        }
        let person = presenter.objects[indexPath.row]
        cell.set(indexPath: indexPath, person: person)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

extension StatisticsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = presenter.objects[indexPath.row]
        let vc = UserInfoView(object: object)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

