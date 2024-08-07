//
//  NFTCardController.swift
//  FakeNFT
//
//  Created by Денис Николаев on 02.08.2024.
//

import UIKit
import Kingfisher
import ProgressHUD
import CHIPageControl

// MARK: - Final Class

final class NFTCardViewController: UIViewController {
    private let swipeGestureRecognizer = UISwipeGestureRecognizer()
    private var presenter: NFTCardPresenterProtocol
    private var heightConstraintCV = NSLayoutConstraint()
    weak var delegate: NFTCollectionCelllDelegate?
    weak var delegatee: NFTCollectionUpdaterDelegate?

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(NFTCardCell.self)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var pageControl: CHIPageControlJaloro = {
        let pageControl = CHIPageControlJaloro()
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.currentPageTintColor = .black
        pageControl.tintColor = .lightGray
        pageControl.padding = 8
        pageControl.elementWidth = 109
        pageControl.elementHeight = 4
        return pageControl
    }()

    private lazy var addToCart: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить в корзину", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cartItemAdded), for: .touchUpInside)
        return button
    }()

    private lazy var buttonSeller: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт продавца", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(launchWebsiteViewer), for: .touchUpInside)
        return button
    }()

    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return image
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .red
        button.addTarget(self, action: #selector(userDidLike), for: .touchUpInside)
        button.setImage(UIImage(named: "likeNotActive"), for: .normal)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        return scrollView
    }()

    private lazy var nameNft: UILabel = {
        let label = UILabel()
        label.textColor =  .black
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.text = "Daisy"
        return label
    }()

    private lazy var nameCollection: UILabel = {
        let label = UILabel()
        label.textColor =  .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.text = "Peach"
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor =  .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.text = "Цена"
        return label
    }()

    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor =  .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.text = "1 ETH"
        return label
    }()

    private lazy var ratingStarsView: DynamicRatingView = {
        let view = DynamicRatingView()
        return view
    }()

    private lazy var nftCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(NFTCollectionCelll.self, forCellWithReuseIdentifier: "NFTCollectionCelll")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
        presenter.setupData(data: presenter.nftArray)
        presenter.setupDataNft(data: presenter.nftCollection)
        setup()
        updateLikeButtonImage()
        setupNavBackButton()
        presenter.presentCollectionViewData()
        swipeGestureRecognizer.direction = .left
        swipeGestureRecognizer.isEnabled = true
        swipeGestureRecognizer.addTarget(self, action: #selector(handleSwipe))
        coverImageView.addGestureRecognizer(swipeGestureRecognizer)
        coverImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setup() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        [coverImageView, pageControl, nameNft, ratingStarsView, nameCollection, priceLabel, nftPriceLabel, addToCart, tableView, buttonSeller, nftCollection].forEach {
            scrollView.addSubview($0)
        }

        var topbarHeight: CGFloat {
            let statusBarHeight = navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            return statusBarHeight + navigationBarHeight
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }

        nameNft.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(16)
            make.leading.equalTo(scrollView).offset(16)
        }

        nameCollection.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(nameNft)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(nameNft.snp.bottom).offset(24)
        }

        nftPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
        }

        addToCart.snp.makeConstraints { make in
            make.top.equalTo(priceLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
            make.width.equalTo(240)
        }

        ratingStarsView.snp.makeConstraints { make in
            make.centerY.equalTo(nameNft)
            make.leading.equalTo(nameNft.snp.trailing).offset(8)
            make.height.equalTo(12)
            make.width.equalTo(68)
        }

        coverImageView.snp.makeConstraints { make in
            make.height.equalTo(310)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(scrollView)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(-topbarHeight)
            make.leading.equalTo(view)
            make.bottom.equalTo(view)
            make.trailing.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(addToCart.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(576)
        }

        buttonSeller.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(40)
        }

        nftCollection.snp.makeConstraints { make in
            make.top.equalTo(buttonSeller.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(172)
            make.bottom.equalTo(scrollView).offset(-16)
        }
    }

    private func setupNavBackButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }

    // MARK: - @objc func

    @objc func goBack() {
        delegatee?.updateNFTCollection()
        navigationController?.popViewController(animated: true)
    }

    @objc func userDidLike() {
        ProgressHUD.show()
        updateLikeButtonImage()
        let nftModell = presenter.nftArray
        presenter.toggleLikeStatus(model: nftModell)
        ProgressHUD.dismiss()
    }

    @objc func cartItemAdded() {
        ProgressHUD.show()
        let nftModell = presenter.nftArray
        presenter.toggleCartStatus(model: nftModell)
        ProgressHUD.dismiss()
    }

    @objc func handleSwipe() {
        coverImageView.kf.setImage(with: presenter.ima[(presenter.currentIndex + 1) % presenter.ima.count], options: [.keepCurrentImageWhileLoading])
        presenter.currentIndex = (presenter.currentIndex + 1) % presenter.ima.count
        UIView.transition(with: coverImageView, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: { [weak self] _ in
            self?.pageControl.set(progress: self!.presenter.currentIndex, animated: true)
        })
    }

    @objc func imageTapped() {
        let destinationViewController = PhotoViewController(image: presenter.ima, currentIndex: presenter.currentIndex)
        self.present(destinationViewController, animated: true, completion: nil)
    }

    @objc func launchWebsiteViewer(_ gesture: UITapGestureRecognizer) {
        let urlString = presenter.getUserProfile()?.website ?? ""

        if let url = URL(string: urlString) {
            let webPresenter = WebViewPresenter()
            let webVC = WebViewController(
                presenter: webPresenter,
                url: url
            )
            setupNavBackButton()
            webVC.hidesBottomBarWhenPushed = true
            navigationItem.backBarButtonItem =  UIBarButtonItem(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )
            navigationController?.pushViewController(
                webVC,
                animated: true
            )
        }
    }

}

extension NFTCardViewController: NFTCardViewControllerProtocol {
    func renderViewData(viewData: CatalogCollectionViewData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadCoverImage(url: "\(viewData.coverImageURL)")
            self.nameNft.text = viewData.title
            presenter.ima = viewData.images
        }
    }

    func setupData(data: Nft) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.ratingStarsView.configureRating(data.rating)
            self.nftPriceLabel.text = "\(data.price) ETH"
        }
    }

    func setupDataNft(data: NFTCollection) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.nameCollection.text = data.name
        }
    }

    func configureLikeButtonImage(_ isAlreadyLiked: Bool) {
        let likeName = isAlreadyLiked ? "likeActive" : "likeNotActive"
        likeButton.setImage(UIImage(named: likeName), for: .normal)
    }

    func updateLikeButtonImage() {
        let nftModel = presenter.nftArray
        let isAlreadyLiked = presenter.isAlreadyLiked(nftId: nftModel.id) ?? false
        let isAlreadyIn = isAlreadyLiked
        configureLikeButtonImage(isAlreadyLiked)
    }

    func reloadVisibleCells() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            updateLikeButtonImage()
            self.nftCollection.visibleCells.forEach { cell in
                guard let nftCell = cell as? NFTCollectionCelll else {
                    return
                }
                nftCell.updateLikeButtonImage()
                nftCell.updateCartButtonImage()
            }
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
    func setupData(data: Nft)
    func setupDataNft(data: NFTCollection)
    func reloadVisibleCells()
}

extension NFTCardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.cryptos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NFTCardCell = tableView.dequeueReusableCell()
        let data = presenter.cryptos[indexPath.row]
        cell.configure(with: data)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}

extension NFTCardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = presenter.nftArrays.count
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCelll = collectionView.dequeueReusableCell(indexPath: indexPath)
        let data = presenter.nftArrays[indexPath.row]
        cell.setNftModel(data)
        cell.presenter = presenter
        cell.delegate = self
        cell.renderCellForModel()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: 108,
            height: 172
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
}
extension NFTCardViewController: NFTCollectionCelllDelegate {
    func onLikeButtonTapped(cell: NFTCollectionCelll) {
        guard let nftModel = cell.getNftModel() else {
            return
        }
        presenter.toggleLikeStatus(model: nftModel)
    }

    func addToCartButtonTapped(cell: NFTCollectionCelll) {
        guard let nftModel = cell.getNftModel() else {
            return
        }
        presenter.toggleCartStatus(model: nftModel)
    }
}
