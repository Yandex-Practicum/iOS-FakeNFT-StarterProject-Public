//
//  NFTCardController.swift
//  FakeNFT
//
//  Created by Денис Николаев on 02.08.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

// MARK: - Final Class

final class NFTCardViewController: UIViewController {

    private var presenter: NFTCardPresenterProtocol
    private var heightConstraintCV = NSLayoutConstraint()

    private let itemsPerRow = 3
    private let bottomMargin: CGFloat = 55
    private let cellHeight: CGFloat = 172

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor =  .black
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "Автор коллекции:"
        return label
    }()

    private lazy var authorLink: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(launchWebsiteViewer))
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(red: 10, green: 132, blue: 255, alpha: 1)
        label.backgroundColor = .white
        label.addGestureRecognizer(tapGesture)
        return label
    }()

    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()

    init(presenter: NFTCardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        presenter.viewController = self
//        presenter.loadNFTs()
        setup()
        setupNavBackButton()
        presenter.presentCollectionViewData()
    }

    private func setup() {
        view.addSubview(scrollView)
        view.backgroundColor = .white

        scrollView.addSubview(contentView)

        [coverImageView, titleLabel, authorLabel, authorLink, collectionDescriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        var topbarHeight: CGFloat {
            let statusBarHeight = navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            return statusBarHeight + navigationBarHeight
        }

     //   heightConstraintCV = nftCollection.heightAnchor.constraint(equalToConstant: 0)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(-topbarHeight)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.leading.equalTo(scrollView)
            make.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        coverImageView.snp.makeConstraints { make in
            make.height.equalTo(310)
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.lessThanOrEqualTo(contentView)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(114)
        }

        authorLink.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(authorLabel.snp.trailing).offset(4)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(authorLabel.snp.bottom).offset(1)
            make.height.equalTo(28)
        }

        collectionDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }

//        nftCollection.snp.makeConstraints { make in
//            make.top.equalTo(collectionDescriptionLabel.snp.bottom).offset(24)
//            make.leading.equalTo(contentView).offset(16)
//            make.trailing.equalTo(contentView).offset(-16)
//            make.bottom.equalTo(contentView)
//        }
//        
//        heightConstraintCV.isActive = true
    }

    private func setupNavBackButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(goBack))
    }

    private func calculateCollectionHeight(itemCount: Int) {
        let numRows = (itemCount + itemsPerRow - 1) / itemsPerRow
        heightConstraintCV.constant = CGFloat(numRows) * cellHeight + bottomMargin
    }

    // MARK: - @objc func

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func launchWebsiteViewer(_ gesture: UITapGestureRecognizer) {
        let urlString = presenter.getUserProfile()?.website ?? ""

        if let url = URL(string: urlString) {
            let webPresenter = WebViewPresenter()
            let webVC = WebViewController(presenter: webPresenter, url: url)
            setupNavBackButton()
            webVC.hidesBottomBarWhenPushed = true
            navigationItem.backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

extension NFTCardViewController: NFTCardViewControllerProtocol {
    func renderViewData(viewData: CatalogCollectionViewData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadCoverImage(url: viewData.coverImageURL)
            self.titleLabel.text = viewData.title
            self.authorLink.text = viewData.authorName
            self.collectionDescriptionLabel.text = viewData.description
        }
    }

    private func loadCoverImage(url: String) {
        guard let imageUrl = URL(string: url.urlDecoder ?? "") else {
            return
        }
        coverImageView.kf.setImage(with: imageUrl)
    }
}

protocol NFTCardViewControllerProtocol: AnyObject {
    func renderViewData(viewData: CatalogCollectionViewData)
}
