import UIKit

struct SortingModel {
    let action: (_ filter: Sortings?) -> Void
}

protocol SortingView {
    func showSortingMenu(_ model: SortingModel)
}

extension SortingView where Self: UIViewController {
    
    func showSortingMenu(_ model: SortingModel) {
        let alert = UIAlertController(
            title: NSLocalizedString("Sorting.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for sorting in Sortings.allCases {
            let setFilterAction1 = UIAlertAction(title: sorting.rawValue, style: .default) {_ in
                model.action(sorting)
            }
            alert.addAction(setFilterAction1)
        }
        
        let closeAction = UIAlertAction(title: NSLocalizedString("Sorting.close", comment: ""), style: .cancel)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
}
