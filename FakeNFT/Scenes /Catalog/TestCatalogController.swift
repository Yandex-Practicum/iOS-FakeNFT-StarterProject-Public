import UIKit

final class TestCatalogViewController: UIViewController {

  @IBAction func showNft() {
    let nftInput = NftDetailInput(id: "22")
    let nftViewController = NftDetailAssembly().build(with: nftInput)
    present(nftViewController, animated: true)
  }
}
