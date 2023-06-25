import UIKit

final class ProfileViewModel {
    
    var onChange: (() -> Void)?
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
}
