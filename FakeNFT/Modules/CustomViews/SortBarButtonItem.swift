import UIKit

final class SortBarButtonItem: UIBarButtonItem {
    init(target: AnyObject?, action: Selector?) {
        super.init()
        self.setup(target: target, action: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(target: AnyObject?, action: Selector?) {
        self.target = target
        self.action = action
        self.image = .Icons.sort
    }
}
