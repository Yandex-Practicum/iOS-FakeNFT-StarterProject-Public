import UIKit

protocol NftDetailView: AnyObject {
  func displayCells(_ cellModels: [NftDetailCellModel])
}

final class NftDetailViewController: UIViewController {

  let presenter: NftDetailPresenter

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
    presenter.loadImages()
  }
}

extension NftDetailViewController: NftDetailView {
  func displayCells(_ cellModels: [NftDetailCellModel]) {
    print(cellModels)
    // TODO: reload collectionView
  }
}
