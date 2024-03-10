import UIKit

final class NftCollectionViewController: UIViewController {
	
	// MARK: Public properties
	
	var viewModel: NftCollectionViewModel?
	
	// MARK: Private properties
	
	private let cellReuseIdentifier = "cell"
	
	// MARK: Private UI Properties
	
	private lazy var backButton = {
		let image = UIImage(systemName: "chevron.backward")
		let button = UIButton()
		
		button.setImage(image, for: .normal)
		button.tintColor = .textColor
		button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
		
		return UIBarButtonItem(customView: button)
	}()
	
	private lazy var collectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: UICollectionViewFlowLayout()
		)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		return collectionView
	}()
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
		bindViewModelProperties()
		
		viewModel?.getOrder()
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		view.backgroundColor = .systemBackground
		self.navigationItem.leftBarButtonItem = backButton
		
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.title = NSLocalizedString(
			"NftCollection",
			comment: ""
		)
		
		view.addSubview(collectionView)
		
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(
			NftCollectionCell.self,
			forCellWithReuseIdentifier: cellReuseIdentifier
		)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	private func bindViewModelProperties() {
		viewModel?.$nfts.bind { [weak self] _ in
			self?.collectionView.performBatchUpdates {
				guard let self,
					  let row = self.viewModel?.nfts.count else {
					return
				}
				
				self.collectionView.insertItems(
					at: [IndexPath(row: row - 1, section: 0)]
				)
			}
		}
	}
	
	@objc private func backButtonDidTap() {
		dismiss(animated: true)
	}
}


// MARK: UICollectionViewDataSource

extension NftCollectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel?.nfts.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: cellReuseIdentifier,
			for: indexPath
		) as? NftCollectionCell,
			  let viewModel else {
			return NftCollectionCell()
		}
		
		cell.viewModel = viewModel.nfts[indexPath.item]
		cell.delegate = self
		
		return cell
	}
}

// MARK: UICollectionViewDelegate

extension NftCollectionViewController: UICollectionViewDelegate {
	
}

// MARK: UICollectionViewDelegateFlowLayout

extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 108, height: 192)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		9
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		8
	}
}

// MARK: NftCollectionCellDelegate

extension NftCollectionViewController: NftCollectionCellDelegate {
	func likeDidTap(id: String, isLiked: Bool) {
		viewModel?.setLiked(id: id, isLiked: isLiked)
	}
	
	func cartDidTap(id: String, isAdded: Bool) {
		viewModel?.cart(id: id, isAdded: isAdded)
	}
}
