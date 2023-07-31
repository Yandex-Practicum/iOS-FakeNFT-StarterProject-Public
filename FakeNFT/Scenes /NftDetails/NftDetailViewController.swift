import UIKit
import Kingfisher

protocol NftDetailView: AnyObject {
  func displayCells(_ cellModels: [NftDetailCellModel])
}

final class NftDetailViewController: UIViewController {

  private let presenter: NftDetailPresenter
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
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
//    collectionView.delegate = self

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

final class NftImageCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
  private lazy var imageView: UIImageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    imageView.constraintEdges(to: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with cellModel: NftDetailCellModel) {
    imageView.kf.setImage(with: cellModel.url)
  }
}
