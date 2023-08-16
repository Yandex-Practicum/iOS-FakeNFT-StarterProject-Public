import UIKit

protocol CartPaymentCollectionViewHelperDelegate: AnyObject {
    var currencies: [CurrencyCellViewModel] { get }
    func cartPaymentCollectionViewHelper(
        _ cartPaymentCollectionViewHelper: CartPaymentCollectionViewHelper,
        didSelectCurrencyId id: String
    )
}

protocol CartPaymentCollectionViewHelperProtocol: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var delegate: CartPaymentCollectionViewHelperDelegate? { get set }
}

final class CartPaymentCollectionViewHelper: NSObject {
    private enum Insets {
        static let collectionView = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let horizontalSpacing: CGFloat = 7
        static let verticalSpacing: CGFloat = 7
    }

    weak var delegate: CartPaymentCollectionViewHelperDelegate?
}

// MARK: - CartPaymentCollectionViewHelperProtocol
extension CartPaymentCollectionViewHelper: CartPaymentCollectionViewHelperProtocol {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let leftInset = Insets.collectionView.left
        let rightInset = Insets.collectionView.right
        let horizontalSpacing = Insets.horizontalSpacing

        let cellsPerRow: CGFloat = 2
        let cellsHorizontalSpace = leftInset + rightInset + horizontalSpacing * cellsPerRow

        let width = (collectionView.bounds.width - cellsHorizontalSpace) / cellsPerRow
        return CGSize(width: width, height: 46)
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        Insets.horizontalSpacing
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        Insets.verticalSpacing
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetForSectionAt _: Int
    ) -> UIEdgeInsets {
        Insets.collectionView
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell: CartPaymentCollectionViewCell = collectionView.cellForItem(indexPath: indexPath)
        guard let currency = cell.currency else { return }

        cell.shouldSelectCell(true)
        self.delegate?.cartPaymentCollectionViewHelper(self, didSelectCurrencyId: currency.id)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        let cell: CartPaymentCollectionViewCell = collectionView.cellForItem(indexPath: indexPath)
        cell.shouldSelectCell(false)
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.delegate?.currencies.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CartPaymentCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let currency = self.delegate?.currencies[indexPath.row]
        cell.currency = currency
        return cell
    }
}
