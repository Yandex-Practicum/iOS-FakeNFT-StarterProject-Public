import UIKit
import FakeNFT

final class CartTableViewHelperStub: NSObject {
    var didNumberOfRowsInSectonsCalled = false
    var didCellForRowCalled = false
}

// MARK: - CartTableViewHelperProtocol
extension CartTableViewHelperStub: CartTableViewHelperProtocol {
    var delegate: FakeNFT.CartTableViewHelperDelegate? {
        get { nil }
        set(newValue) {}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.didNumberOfRowsInSectonsCalled = true
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.didCellForRowCalled = true
        return UITableViewCell()
    }
}
