
import Foundation

protocol EditingProfilePresenterProtocol {
    var profile: ProfileModelUI { get }
}

final class EditingProfilePresenter: EditingProfilePresenterProtocol {
    var profile: ProfileModelUI
    
    init(profile: ProfileModelUI) {
        self.profile = profile
    }
    
    
    
}
