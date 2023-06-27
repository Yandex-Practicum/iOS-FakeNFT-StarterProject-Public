import UIKit

final class EditProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = EditProfileView(frame: .zero, viewController: self)
    }
    
}
