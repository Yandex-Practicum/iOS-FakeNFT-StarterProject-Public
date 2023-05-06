import UIKit

final class ProductDetailsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ProductDetailsTableViewCell.self)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductDetailsTableViewCell = tableView.dequeueReusableCell()

        cell.textLabel?.text = "Ячейка номер \(indexPath.row)"

        return cell
    }
}
