import UIKit
import FakeNFT

final class CartTableViewHelperStub: NSObject {

}

extension CartTableViewHelperStub: CartTableViewHelperProtocol {
    var delegate: FakeNFT.CartTableViewHelperDelegate? {
        get { nil }
        set {}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
