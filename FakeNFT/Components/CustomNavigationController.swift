import UIKit

final class CustomNavigationController: UINavigationController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .whiteDay
        navigationBar.tintColor = .blackDay
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
