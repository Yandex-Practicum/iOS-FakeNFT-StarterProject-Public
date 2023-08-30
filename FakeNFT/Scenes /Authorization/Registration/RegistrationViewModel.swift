import UIKit
import Firebase

final class RegistrationViewModel: RegistrationViewModelProtocol {
    
    // MARK: - Constants and Variables:
    var errorDiscription: String?
    
    private var newLogin: String? {
        didSet {
            isReadyToCreateNewAccount()
        }
    }
    
    private var newPassword: String? {
        didSet {
            isReadyToCreateNewAccount()
        }
    }
    
    private let availableMailBoxes = ["@mail.ru", "@gmail.com", "@yandex.ru", "@mail.com", "@rambler.ru"]
    
    // MARK: - Observable Values:
    var isUserMistakeObservable: Observable<Bool?> {
        $isUserMistake
    }
    
    var isInputPasswordCorrectObservable: Observable<Bool?> {
        $isInputPasswordCorrect
    }
    
    var isInputMailCorrectObservable: Observable<Bool?> {
        $isInputMailCorrect
    }
    
    var isRegistrationDidSuccesfulObserver: Observable<Bool?> {
        $isRegistrationDidSuccesful
    }
    
    @Observable
    private(set) var isRegistrationDidSuccesful: Bool?
    
    @Observable
    private(set) var isInputPasswordCorrect: Bool?
    
    @Observable
    private(set) var isInputMailCorrect: Bool?
    
    @Observable
    private(set) var isUserMistake: Bool?
    
    // MARK: - Public Methods:
    func setNewLoginPassword(login: String, password: String) {
        self.newLogin = login
        self.newPassword = password
    }
    
    func registrateNewAccount() {
        guard let email = newLogin, let password = newPassword else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if error != nil {
                guard let error = error as? NSError else { return }
                self.errorDiscription = error.code == 17007 ? L10n.Authorization.Error.loginIsBusy : L10n.Alert.Authorization.message
                self.isRegistrationDidSuccesful = false
            }
            
            if user != nil {
                self.isRegistrationDidSuccesful = true
            } else {
                self.errorDiscription = L10n.Authorization.Error.loginPasswordMistake
                self.isUserMistake = true
            }
        }
    }
    
    // MARK: - Private Methods:
    private func isReadyToCreateNewAccount() {
        guard let newLogin = newLogin, let newPassword = newPassword else { return }
        
        if newLogin.count > 0 && newPassword.count > 0 {
            if newPassword.count < 6 {
                errorDiscription = L10n.Authorization.Error.passwordMistake
                isInputPasswordCorrect = false
            } else if !isMailBox() {
                errorDiscription = L10n.Authorization.Error.mailMistake
                isInputMailCorrect = false
            } else {
                isInputPasswordCorrect = true
                isInputMailCorrect = true
            }
        }
    }
    
    private func isMailBox() -> Bool {
        guard let newLogin = newLogin else { return false }
        
        for mail in availableMailBoxes where newLogin.contains(mail) {
            return true
        }
        return false
    }
}
