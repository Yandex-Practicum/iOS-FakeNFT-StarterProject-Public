import UIKit

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: ProfileViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = EditProfileView(frame: .zero, viewController: self)
    }
}
