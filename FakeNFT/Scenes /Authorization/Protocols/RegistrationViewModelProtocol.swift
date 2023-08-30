import Foundation

protocol RegistrationViewModelProtocol: AnyObject {
    var errorDiscription: String? { get }
    var isUserMistakeObservable: Observable<Bool?> { get }
    var isInputPasswordCorrectObservable: Observable<Bool?> { get }
    var isInputMailCorrectObservable: Observable<Bool?> { get }
    var isRegistrationDidSuccesfulObserver: Observable<Bool?> { get }
    func setNewLoginPassword(login: String, password: String)
    func registrateNewAccount()
}
