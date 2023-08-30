import UIKit
import Firebase

final class AuthViewModel: AuthViewModelProtocol {
    
    // MARK: - Constants and Variables:
    private var login: String?
    private var password: String?
    
    // MARK: Observable Values:
    var loginPasswordMistakeObservable: Observable<Bool?> {
        $loginPasswordMistake
    }
    
    var isAuthorizationDidSuccesfulObserver: Observable<Bool?> {
        $isAuthorizationDidSuccesful
    }
    
    @Observable
    private(set) var loginPasswordMistake: Bool?
    
    @Observable
    private(set) var isAuthorizationDidSuccesful: Bool?
    
    // MARK: Public Methods:
    func setNewLoginPassword(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    func authorize() {
        guard let email = login, let password = password else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            if error != nil {
                self.isAuthorizationDidSuccesful = false
            }
            
            if user != nil {
                self.isAuthorizationDidSuccesful = true
            } else {
                self.loginPasswordMistake = true
            }
        }
    }
}
