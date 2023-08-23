import UIKit

final class TestCatalogViewController: UIViewController {
    
    var servicesAssembly: ServicesAssembly?
    
    @IBAction func showNft() {
        guard let servicesAssembly = servicesAssembly else {
            assertionFailure("servicesAssembly is nil")
            return
        }
        
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: "22")
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
}
