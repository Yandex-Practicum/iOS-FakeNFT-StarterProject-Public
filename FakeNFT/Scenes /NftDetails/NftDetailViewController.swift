import UIKit
import Kingfisher

protocol NftDetailView: AnyObject {
  func displayCells(_ cellModels: [NftDetailCellModel])
}

final class NftDetailViewController: UIViewController {

  private let presenter: NftDetailPresenter
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  private var cellModels: [NftDetailCellModel] = []

  init(presenter: NftDetailPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    setup()
    presenter.loadImages()
  }

  private func setup() {
    collectionView.register(NftImageCollectionViewCell.self)
    collectionView.dataSource = self
    collectionView.delegate = self

    collectionView.showsHorizontalScrollIndicator = true
    collectionView.isPagingEnabled = true

    view.addSubview(collectionView)
    collectionView.constraintEdges(to: view)
  }
}

extension NftDetailViewController: NftDetailView {
  func displayCells(_ cellModels: [NftDetailCellModel]) {
    self.cellModels = cellModels
    collectionView.reloadData()
  }
}

extension NftDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    cellModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: NftImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)

    let cellModel = cellModels[indexPath.row]
    cell.configure(with: cellModel)

    return cell
  }
}

extension NftDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionView.bounds.size
  }
}

final class NftImageCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0
    return scrollView
  }()

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(scrollView)
    scrollView.constraintEdges(to: contentView)

    scrollView.addSubview(imageView)
    imageView.constraintCenters(to: scrollView)
    imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with cellModel: NftDetailCellModel) {
    imageView.kf.setImage(with: cellModel.url)
  }
}

extension NftImageCollectionViewCell: UIScrollViewDelegate {

  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
  }

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
}
