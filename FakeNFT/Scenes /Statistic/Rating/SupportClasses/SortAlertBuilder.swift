import UIKit

final class SortAlertBuilder {

    private init() {}

    static func buildSortAlert(
        onNameSort: @escaping () -> Void,
        onRatingSort: @escaping () -> Void) -> UIAlertController {
            let sortAlertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

            sortAlertController.addAction(UIAlertAction(title: "По имени", style: .default) { _ in
                onNameSort()
            })
            sortAlertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
                onRatingSort()
            })
            sortAlertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

            return sortAlertController
        }

    static func buildSortAlert(
        onPriceSort: @escaping () -> Void,
        onRatingSort: @escaping () -> Void,
        onNameSort: @escaping () -> Void
    ) -> UIAlertController {
        let sortAlertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        sortAlertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            onPriceSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            onRatingSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            onNameSort()
        })
        sortAlertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        return sortAlertController
    }
}
