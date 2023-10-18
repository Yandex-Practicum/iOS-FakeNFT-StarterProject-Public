import UIKit

final class YPNavigationController: UINavigationController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        navigationBar.backgroundColor = .ypWhiteWithDarkMode
        navigationBar.tintColor = .ypBlackWithDarkMode
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
